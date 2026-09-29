# Jaguza Livestock Platform — API Reference

Reverse-engineered from the **JaguzaLivestockApp** Android client (`com.afrosoft.jaguza`, v2.83.9 / code 87).
Purpose: give you enough detail to re-implement the same features on another backend or client.

> **How this was produced.** Every endpoint, parameter and response field below was read out of the client source
> (Retrofit interfaces, AndroidNetworking / HttpURLConnection call sites, and the Gson/Kotlin model classes the
> client deserialises responses into). **The server code was not available**, so:
> - Request parameters are exact (what the client sends).
> - Response fields are exact *only where the client parses them into a model*. Where the client ignores the body, it says *"not inspected"*.
> - Business rules, validation and DB schema are **not** known — they are inferred and flagged as such.
> - The iOS repo (`JaguzaFarmApp-iOS`) contains no source (the `jaguzaapp` folder is an unresolved submodule pointer), so nothing here comes from it. It uses the same Podfile-level integrations, so it very likely calls the same APIs.

---

## 0. Contents

1. [Backends and base URLs](#1-backends-and-base-urls)
2. [Conventions](#2-conventions-transport-auth-envelopes)
3. [Auth and accounts (v2)](#3-auth-and-accounts-v2)
4. [Farms and farm users (v2)](#4-farms-and-farm-users-v2)
5. [Animal categories, breeds, animals (v2)](#5-animal-categories-breeds-animals-v2)
6. [Breeding cycle records (v2)](#6-breeding-cycle-records-v2)
7. [Milking, feeding, health, need-attention (v2)](#7-milking-feeding-health-need-attention-v2)
8. [Finance: expenses and income (v2)](#8-finance-expenses-and-income-v2)
9. [Reports and analytics (v2)](#9-reports-and-analytics-v2)
10. [Marketplace 1 — stores, requests, store products (v2 `mkt_*`)](#10-marketplace-1--stores-requests-store-products-v2-mkt_)
11. [Marketplace 2 — `market.jaguzafarm.com` REST API](#11-marketplace-2--marketjaguzafarmcom-rest-api)
12. [Adverts](#12-adverts)
13. [Farm API v1 (Retrofit, `:8000/`)](#13-farm-api-v1-retrofit-8000)
14. [Diagnosis / decision support service](#14-diagnosis--decision-support-service)
15. [Legacy `cmd` command API](#15-legacy-cmd-command-api)
16. [Push, chat, video, sensors](#16-push-chat-video-sensors)
17. [Third-party services](#17-third-party-services)
18. [Data models](#18-data-models)
19. [Dead / unused endpoints](#19-dead--unused-endpoints)
20. [Rebuild notes and security findings](#20-rebuild-notes-and-security-findings)

---

## 1. Backends and base URLs

The app talks to **several generations of backend**. Names below are used throughout this document.

| Alias | Base URL | Used for | Client |
|---|---|---|---|
| **V2** | `http://livestock.jaguzafarm.com:8000/v2/` | Current farm module (`frm_*`), auth, store marketplace (`mkt_*`), adverts | AndroidNetworking |
| **V1** | `http://livestock.jaguzafarm.com:8000/` | Older farm/marketplace endpoints (`fetch_*`, `insert_*`) | Retrofit (`ExploreService`) |
| **CMD** | `https://jaguzalivestockug.com/mobileapp/api/` | Legacy command API (`cmd=<name>`), diagnosis, decision support, chat push | HttpURLConnection / Retrofit / AndroidNetworking |
| **MARKET** | `https://market.jaguzafarm.com/api/` | REST marketplace (products, cart, orders) | AndroidNetworking |
| **ADVERT** | `http://livestock.jaguzafarm.com:8081/api/` (+ `/pictures/`) | Advert service constants (`BASE_ADVERT_URL`) | — (declared; adverts actually fetched via V2) |
| **SENSOR** | `http://livestock.jaguzafarm.com:8083/location_sensor/` | QR / location sensor lookup | AndroidNetworking |
| **IMAGES** | `http://livestock.jaguzafarm.com:8000/FarmAnimalImages/` (also `:8080/FarmAnimalImages/`) | Animal photos: `IMAGES + animal.photo` | Glide |

Static content pages under CMD (open in a WebView / browser, not JSON): `about/`, `faq/`, `terms/`, `facebook/`, `twitter/`, `marketprices/`.
Also: `http://jaguzalivestockug.com/termsandconditions.html`, `.../privacypolicy.html`, `https://jaguzafarm.com/`.

Older hosts still present in the code but **commented out / dev-only** (do not rely on them): `lyk.rkl.mybluehost.me/{jaguzafarmapi, jaguzafarm_app/api, jaguzafarmmarket/api}`, `192.168.1.x` LAN addresses, `208.68.36.69:8000/v2/`.

## 2. Conventions: transport, auth, envelopes

**Transport.** Everything is HTTP `POST` with `application/x-www-form-urlencoded` bodies unless marked `GET`, `multipart`, or `DELETE`. There are **no JSON request bodies** in the farm/CMD APIs. Params are sent as plain string fields (numbers as strings). Timeouts on the CMD transport: 15 s connect/read.

**Authentication.** There is **no token / session / header auth** on V1, V2, CMD or MARKET. Identity is a plain `user_id` (or `userId`, `farm_id`, `email`) field in the request body. The server is trusted to accept whatever id the client sends. If you rebuild this, **add real auth** (see §20). The only `Authorization` headers in the app are for third-party services (§17).

**Response envelopes** (V2):

| Kind | Shape |
|---|---|
| Mutation result | `{"status_code": <int>, "status_message": "<text>"}` — `200` = success. (Some endpoints use `code` instead of `status_code`; noted per endpoint.) |
| List | A **bare JSON array** of objects, no wrapper. Empty result = `[]`. |
| Object | A bare JSON object. |
| Login / store | `{"status_code": 200, "user": "<JSON string>"}` / `{"status_code": 200, "store": "<JSON string>"}` — the client calls `getString("user")` and stores that text, so it is an object (or JSON-encoded string of one). |

Observed status codes: `200` OK · `300` sign-in succeeded but **must reset password** · `400` bad request · `402` failed / not added · `403` already exists.

**MARKET** envelope: `{"message": "...", "data": [ ... ]}` (`data` is an array for lists).

**V1** envelope: mutations return `{"code": <int>, "message": "..."}` (`SignNetworkModel`); lists are bare arrays.

**Field naming.** Two names for the same concept appear: `animal_type_id` and `animal_category_id` both mean *the animal category id* (cattle, goats…). `animal_ref` is the animal's unique id. `farm_id`, `user_id` are ids of the farm and the app user.

---

## 3. Auth and accounts (V2)

Base: **V2**. All `POST` form-urlencoded. Source: `LoginActivity`.

| Endpoint | Params | Response | Notes |
|---|---|---|---|
| `sign_up.php` | `surname`, `first_name`, `email`, `password`, `telephone` | `{status_code, status_message, user}` | `200` → logged in. Otherwise show `status_message`. |
| `sign_in.php` | `email_phone` (email **or** phone), `password` | `{status_code, user, status_message?}` | `200` OK. **`300` = temporary password: force the user through `reset_password.php`.** Other codes → show message. |
| `sign_in_social.php` | `email`, `name` | `{status_code, status_message, user}` | Google/Facebook sign-in. `200` OK, `400`/`402` error. Creates the account if new (inferred). |
| `reset_password.php` | `user_id`, `password` | `{user}` (no status code read) | Sets a new password then logs in. |

`user` object fields the client relies on: `id` (int), `first_name`, `surname`, `email`, `telephone` (+ `picture`, `district`, `firebase_token` in the market `User` model).

Legacy equivalents (V1 / CMD): `farm_login_version_3.php`, `edit_account_info.php` (§13) and `login`, `logincode`, `resendcode`, `addUsers`, `forgotPassword`, `changeEmailApp`, `verifyEmail` (§15).

---

## 4. Farms and farm users (V2)

| Endpoint | Params | Response |
|---|---|---|
| `frm_create.php` | `name`, `country`, `district`, `farm_owner` (user id), `gps_lat`, `gps_lon` | Body not parsed — any non-null response = created. |
| `frm_get_farms.php` | `user_id` | Array of **Farm** (§18). Client shows only `status == "active"`. |
| `frm_delete_farm.php` | `farm_id` | Not inspected (client removes item locally). |
| `frm_get_farm_users.php` | `farm_id` | Array of **FarmUser**. |
| `frm_save_farm_user.php` | `email`, `role`, `farm_id` | `{code}` — `200` added · `403` already in farm · `402` not added. Adds an existing user *by email*. |
| `frm_remove_frm_user.php` | `farm_id`, `user_id` | Not inspected. |

---

## 5. Animal categories, breeds, animals (V2)

| Endpoint | Method | Params | Response |
|---|---|---|---|
| `get_animal_categories.php` | GET | — | Array of **AnimalCategory** (global catalogue). |
| `frm_get_frm_animal_categories.php` | POST | `farm_id` | Array of **AnimalCategory** enabled on the farm (`need_attention` = count of flagged animals). |
| `frm_get_frm_animal_categories_number.php` | POST | `farm_id` | Array of **AnimalCategory** (used for report counts). |
| `frm_save_frm_animal_categories.php` | POST | `farm_id`, `animal_category_id` | Not inspected. Enables a category on a farm. |
| `frm_remove_frm_animal_categories.php` | POST | `farm_id`, `animal_category_id` | `{status_code, status_message}`. |
| `get_animal_breeds.php` | POST | `animal_category_id` | Array of **AnimalBreed**. |
| `frm_get_frm_animals.php` | POST | `farm_id`, `animal_category_id`, optional `sex` | Array of **Animal**. |
| `frm_get_farm_female_animals.php` | POST | `farm_id`, `animal_type_id` | Array of **Animal** (females, for breeding/milking pickers). |
| `frm_create_animal.php` | **multipart** | `farm_id`, `animal_type_id`, `breed_id`, `sex`, `dob`, `weight`, `tag_id`, `alias_name`, `description`, `user_id`, `sensor_temp_id`, `sensor_location_id`, `photo` (file) | `{status_code, status_message}` |
| `frm_edit_animal.php` | **multipart** | same as create **plus** `animal_ref` (no `farm_id`) | `{status_code, status_message}` |
| `frm_delete_animal.php` | POST | `animal_ref` | Not inspected. |
| `frm_get_frm_animals_analysis.php` | POST | `farm_id`, `animal_category_id` | Array of `{id, date, counter}` — animal registrations per day (line graph). |

`sensor_temp_id` / `sensor_location_id` link an animal to a temperature or GPS-tracker device (see §16).

---

## 6. Breeding cycle records (V2)

The breeding cycle is six record types, each with the same three operations. `animal_type_id` = category id.

| Stage | List (POST) | Add (POST) | Delete (POST) |
|---|---|---|---|
| **Heat** | `frm_get_heat_records.php` | `frm_add_heat_record.php` — `animal_ref`, `date`, `observation` | `frm_delete_breeding_heat.php` — `id` |
| **Insemination** | `frm_get_insemination_records.php` | `frm_add_insemination_record.php` — `animal_ref`, `date`, `father`, `method` | `frm_delete_breeding_insermination.php` — `id` *(sic — typo is in the endpoint name)* |
| **Pregnant** | `frm_get_pregnant_records.php` | `frm_add_pregnant_record.php` — `animal_ref`, `date` | `frm_delete_breeding_pregnant.php` — `id` |
| **Calving** | `frm_get_calving_records.php` | `frm_add_calving_record.php` — `animal_ref`, `date`, `number_of_calves` | `frm_delete_breeding_calving.php` — `id` |
| **Lactation** | `frm_get_lactation_records.php` | `frm_add_lactation_record.php` — `animal_ref`, `date` | `frm_delete_breeding_lactation.php` — `id` |
| **Rest** (dry period) | `frm_get_rest_records.php` | `frm_add_rest_record.php` — `animal_ref`, `date` | `frm_delete_breeding_rest.php` — `id` |

- **List params (all six):** `farm_id`, `animal_type_id`. **Response:** array of **Heat / Insemination / Pregnant / Calving / Lactation / Rest** (§18), each embedding the full `animal`.
- **Add responses:** `{status_code, status_message}`.
- `frm_get_breeding_analysis.php` — `farm_id`, `animal_type_id` → `{lactation, pregnant, heat, insemination, calving, rest}` (ints; counts per stage).

**Inferred lifecycle** (from the model fields): heat → insemination (`heat_id` links back) → pregnant (`gestation_date`, `gestation_days`) → calving → lactation → rest. `Animal.breeding_stage` holds the current stage.

---

## 7. Milking, feeding, health, need-attention (V2)

### Milking
| Endpoint | Params | Response |
|---|---|---|
| `frm_add_milking_record.php` | `animal_ref`, `date`, `period`, `quantity` | `{status_code, status_message}`. `period` = morning / afternoon / evening (matches the analysis keys below). |
| `frm_get_daily_milking_record_analysis.php` | `farm_id`, `animal_type_id`, `date` | `{animals, daily, daily_morning, daily_afternoon, daily_evening}` — all read as **strings** (numbers/JSON text). |
| `frm_get_milking_daily_analysis.php` | `farm_id`, `date` | `{today, yesterday, yesterday2, expected}` |
| `frm_get_milking_records_analysis_for_animal.php` | `animal_ref` | Array of `{date, total, milking_records: [Milking]}` |
| `frm_get_frm_milking_analysis.php` | `farm_id`, `animal_category_id` | Array (line-graph series; shape read by the reports screen — same style as `{id,date,…}`). |

The milking screen also lists lactating animals via `frm_get_lactation_records.php` (§6). Response model `MilkedAnimal = {animal, milking: [Milking]}` exists for the "milked animals" screen.

### Feeding
| Endpoint | Params | Response |
|---|---|---|
| `frm_add_feeding_record.php` | `farm_id`, `added_by` (user id), `feed_name`, `animal_type`, `description`, `quantity`, `units`, `feeding_datetime` | `{status_code}` |
| `frm_get_feeding_records.php` | `farm_id`, `animal_type_id` | Array of **Feeding** |

### Farm health events
| Endpoint | Params | Response |
|---|---|---|
| `frm_add_frm_health_event_record.php` | `farm_id`, `title`, `description` | Not inspected |
| `frm_get_frm_health_records.php` | `farm_id` | Array of `{id, title, description, date_time, farm_id}` |

### "Need attention" (manual flags)
| Endpoint | Params | Response |
|---|---|---|
| `frm_add_need_attention_manual.php` | `farm_id`, `animal_ref`, `reason`, `description` | Not inspected |
| `frm_get_need_attention_manual.php` | `farm_id`, `animal_category_id`, `state` (`pending` or resolved) | Array of **NeedAttentionManual** |
| `frm_add_need_attention_manual_resolved.php` | `id`, `comment_resolved` | Not inspected — marks resolved |

"Need attention" also has an **automatic** source: the client reads temperature sensor data (§16) and flags animals outside their category's `min_temp`/`max_temp`. That logic is **client-side**; if you rebuild, decide where to run it.

---

## 8. Finance: expenses and income (V2)

| Endpoint | Params | Response |
|---|---|---|
| `frm_add_expense_record_v2.php` | `farm_id`, `user_id`, `name`, `cost`, `payment_type`, `expense_date`, `comment` | `{status_code, status_message}` |
| `frm_get_expenses.php` | `farm_id` | Array of **Expenses** |
| `frm_add_income_record.php` | `farm_id`, `amount`, `source` | Not inspected |
| `frm_get_income_records.php` | `farm_id` | Array of `{id, amount, source, date_time, farm_id}`. The app sums `amount` client-side and displays **UGX**. |

---

## 9. Reports and analytics (V2)

All return arrays of small time-series objects for line charts, or a count object. Aggregation is done **server-side**, so a rebuild must implement it.

| Endpoint | Params | Response |
|---|---|---|
| `frm_get_frm_expenses_income_analysis.php` | `farm_id`, `animal_category_id` | Array of `{id, date, incomes, expenses}` |
| `frm_get_frm_animals_analysis.php` | `farm_id`, `animal_category_id` | Array of `{id, date, counter}` |
| `frm_get_frm_milking_analysis.php` | `farm_id`, `animal_category_id` | Array (milk quantity per date) |
| `frm_get_breeding_analysis.php` | `farm_id`, `animal_type_id` | `{lactation, pregnant, heat, insemination, calving, rest}` |
| `frm_get_milking_daily_analysis.php` | `farm_id`, `date` | `{today, yesterday, yesterday2, expected}` |
| `frm_get_daily_milking_record_analysis.php` | `farm_id`, `animal_type_id`, `date` | `{animals, daily, daily_morning, daily_afternoon, daily_evening}` |

---

## 10. Marketplace 1 — stores, requests, store products (V2 `mkt_*`)

A store-based marketplace: users open **stores** (by type and country), list **store products**, place **orders**, and post **buy requests** that others comment on. Base **V2**.

### Reference data
| Endpoint | Method | Params | Response |
|---|---|---|---|
| `mkt_get_countries.php` | GET | — | Array of `{id, name}` |
| `mkt_get_stores_types.php` | GET | — | Array of `{id, name}` |
| `mkt_get_animal_categories.php` | POST | — | Array of animal categories |
| `mkt_get_animal_products.php` | POST | — | Array (product kinds, e.g. milk, meat…) |
| `mkt_get_currencies.php` | POST | — | Array of currencies |
| `mkt_get_product_units.php` | POST | — | Array of units |

### Stores
| Endpoint | Method | Params | Response |
|---|---|---|---|
| `mkt_admin_create_store.php` | POST | `user_id`, `name`, `description`, `email`, `phone_number`, `address`, `country_id`, `mkt_store_type_id` | `{status_code, store}` |
| `mkt_admin_get_store.php` | POST | `user_id` | `{status_code, store}` — `200` returns the user's store (**StoreDataModel**); anything else → "No account found", app sends user to create one. One store per user. |
| `mkt_get_stores.php` | POST | `mkt_store_type_id`, `country_id` | Array of **Store** |
| `mkt_admin_get_store_products.php` | POST | `mkt_store_id` | Array of **StoreProducts** (seller's own) |
| `mkt_get_store_products.php` | POST | `animal_category_id`, `page` | Array of **StoreProducts** (public browse, paginated) |
| `mkt_admin_create_store_product.php` | **multipart** | `mkt_store_id`, `name`, `description`, `animal_category_id`, `animal_product_id`, `product_unit_id`, `currency_id`, `quantity`, `price`, `old_price`, + image file(s) | Not inspected |
| `mkt_admin_edit_store_product.php` | **multipart** | `id`, `name`, `description`, `animal_category_id`, `animal_product_id`, `product_unit_id`, `currency_id`, `quantity`, `price`, `old_price`, + image file(s) | Not inspected |

### Orders
| Endpoint | Params | Response |
|---|---|---|
| `mkt_order_stores_products.php` | `user_id`, `mkt_store_id`, `mkt_store_product_id`, `quantity`, `order_price` | Not inspected |
| `mkt_order_stores_equipement_temprary.php` *(sic)* | `user_id`, `mkt_product_id`, `quantity`, `order_price` | Not inspected — ordering a V1 equipment item |
| `mkt_get_stores_products_orders.php` | `user_id` (buyer's orders) **or** `mkt_store_id` (seller's incoming orders) | Array of **StoreOrder** |

### Buy requests ("I'm looking for…")
| Endpoint | Method | Params | Response |
|---|---|---|---|
| `mkt_add_request.php` | multipart | `user_id`, `description`, optional file | Not inspected |
| `mkt_get_requests.php` | POST | — | Array of **MktRequests** (each includes `user` and `comments`) |
| `mkt_add_request_comment.php` | multipart | `mkt_request_id`, `user_id`, `comment`, optional file | Not inspected |
| `mkt_get_request_comments.php` | POST | `mkt_request_id` | Array of **MktRequestsComments** |

---

## 11. Marketplace 2 — `market.jaguzafarm.com` REST API

A cleaner REST-style shop used by the `:market` Android module. Base **MARKET**. Responses are `{message, data}`; JSON bodies are **not** used (form fields / path params / multipart).

| Method | Path | Params | Response |
|---|---|---|---|
| GET | `adverts` | — | `data`: array of **AdvertSlide** |
| GET | `categories` | — | `data`: array of **Category** |
| GET | `products` | — | `data`: array of **Product** (also cached locally in Room) |
| GET | `search/{name}` | path `name` | `data`: array of **Product** |
| GET | `categoryProducts/{categoryId}` | path | `data`: array of **Product** |
| GET | `product/comments/{product_id}` | path | `data`: array of **Comment** |
| POST | `product/comments/{product_id}` | path; body `user_id`, `comment` | `message`; may return `data` |
| GET | `userProducts/{userId}` | path | `data`: array of **ProductUpload** (seller's listings) |
| POST (multipart) | `products` | `user_id`, `category_id`, `name`, `description`, `unit_of_measure`, `stock_available`, `unit_price_seller`, `unit_price_buyer`, `unit_profit`, `seller_location`, image file | `message` |
| POST (multipart) | `products/{product_id}` | same fields as create (no `user_id`), image optional | `message` — **update** |
| DELETE | `products/{product}` | path | `message` |
| GET | `userCartProducts/{userId}` | path | `data`: array of **Cart** |
| POST | `addToCart` | `user_id`, `product_id`, `quantity` | `message` |
| POST | `updateCart/{cart_id}` | path; body `quantity` | `message` |
| POST | `deleteCart/{cart_id}` | path | `message` |
| POST | `orders` | `user_id`, `delivery_mode`, `delivery_location`, `total_order_cost`, `total_profits` | `message` — creates an order from the user's cart (inferred) |
| POST | `orders/{order}` | path; body `order_status` | `message` — status change (seller/admin) |
| GET | `userOrders/{user_id}` | path | `data`: array of **Order** |

**Images:** `https://market.jaguzafarm.com/images/products/<picture>`, `/images/icons/<icon>`, `/images/adverts/<advert_image>`.

**Money model (inferred from field names):** each product has a `unit_price_seller` (what the seller receives), `unit_price_buyer` (what the buyer pays) and `unit_profit` (platform margin = buyer − seller). Orders carry `total_order_cost` and `total_profits`. Orders also have `delivery_mode`, `delivery_fee`, `delivery_location`, `pickup_location`, `delivery_person_details`.

---

## 12. Adverts

Base **V2**.

| Endpoint | Method | Params | Response |
|---|---|---|---|
| `get_adverts_plans.php` | GET | — | Array of **AdvertPlan** `{id, day, amount, created_at}` — price per number of days |
| `get_adverts.php` | GET | — | Array of **Advert** |
| `create_advert.php` | multipart | advert fields (title, description, link, contact, `days`/plan, image…; exact list built dynamically in `CreateAdvertActivity`) | `{status_code}` |

The **MARKET** API has its own `adverts` list (§11) shaped as **AdvertSlide**.

---

## 13. Farm API v1 (Retrofit, `:8000/`)

Older farm and marketplace endpoints, defined in `ExploreService.java`. Base **V1**. Form-urlencoded unless marked. Mutations return `{code, message}`. **Much of the app has moved to V2, but these are still compiled in** — see the status column.

### Auth / account
| Endpoint | Params | Response |
|---|---|---|
| `farm_login_version_3.php` | `email`, `password` | `{code, message}` |
| `edit_account_info.php` | `id`, `first_name`, `middle_name`, `surname`, `telephone` | `{code, message}` |
| `send_feedback_from_app.php` | `comment`, `email_address`, `full_names` | `{code, message}` |

### Reference
| Endpoint | Params | Response |
|---|---|---|
| `fetch_animal_types.php` | — | Array of **AnimalType** |
| `fetch_animal_type.php` | `animal_type` | Single **AnimalType** |
| `fetch_animal_breeds.php` | `animal_type` | Array of **AnimalBreed** |
| `fetch_currencies.php` | — | Array of `{id, title, full_title}` |
| `fetch_mkt_equipments_categories.php` | — | Array of `{id, title}` |

### Animals
| Endpoint | Params | Response |
|---|---|---|
| `fetch_animals.php` | `farm_id` (+ optional `sex`) | Array of **Animal (V1)** |
| `fetch_animals_breeding.php` | `farm_id` | Array of Animal |
| `fetch_animals_need_attention.php` | `farm_id` | Array of Animal (includes `need_attention_*`) |
| `fetch_animals_need_attension_manager.php` *(sic)* | `farm_id` | Array of Animal |
| `insert_animal.php` | `animal_type`, `farm_id`, `tag_id`, `alias_name`, `breed_id`, `sex`, `description`, `herd_id`, `animal_mother`, `birth_date`, `sensor_id`, `price_tag`, `last_weight`, `photo`, `added_by` | `{code, message}` |
| `insert_animal_calf.php` | as `insert_animal` but `calving_id` instead of `added_by` | `{code, message}` |
| `update_animal_info.php` | `animal_ref`, `animal_type`, `tag_id`, `alias_name`, `breed_id`, `sex`, `description`, `herd_id`, `birth_date`, `sensor_id` | `{code, message}` |
| `delete_farm_animal.php` | `animal_ref` | `{code, message}` |
| `save_pictures.php` | multipart: `file`, `animal_ref` (or `name`) | `{code, message}` / raw string |
| `save_pictures_2.php` | multipart: `file[]` | `{code, message}` |
| `insert_animal_need_attention.php` | `animal_id`, `farm_id`, `description` | `{code, message}` |
| `delete_animal_need_attention.php` | `need_attention_id` | `{code, message}` |

### Herds
| Endpoint | Params |
|---|---|
| `insert_animal_herd.php` | `herd_name`, `animal_type`, `description`, `created_by`, `animal_icons` |
| `delete_animal_herd.php` | `herd_id` |
| `transfer_animal_to_herd.php` | `animal_ref`, `herd_id` |

### Records
| Endpoint | Params |
|---|---|
| `insert_records_heat.php` | `animal_ref`, `date`, `time`, `comment` |
| `insert_records_pregnant.php` | `animal_ref`, `date` |
| `insert_records_calving.php` | `animal_ref`, `status`, `no_new_borns`, `delivery_notes`, `farm_id`, `date` |
| `insert_records_breeding.php` | `breeding_method`, `genetic_resource`, `service_date`, `animal_id` |
| `insert_module_milk.php` | `animal_ref`, `milking_1`, `time_1`, `milking_2`, `time_2`, `milking_3`, `time_3`, `user_id`, `milking_date`, `remarks` |
| `insert_module_animal_weight.php` | `animal_ref`, `weight`, `comment`, `user_id`, `date` |
| `insert_module_farm_feeds.php` | `farm_id`, `user_id`, `feed_name`, `description`, `animal_type`, `animal_herd`, `quantity`, `units` |
| `delete_module_feeds.php` | `feed_id` |
| `insert_module_animal_sale.php` | `animal_ref`, `price`, `sale_date`, `receipt_no`, `additional_info`, `user_id` |
| `insert_module_farm_expense.php` | `name`, `cost`, `payment_type`, `expense_date`, `comment`, `farm_id`, `user_id` |
| `insert_animal_health_event.php` | `event_name`, `herd_id`, `animal_id`, `start_date`, `event_type`, `comments`, `end_date`, `treatment`, `in_charge`, `created_by` |
| `delete_health_record.php` | `id` |

All the above return `{code, message}`.

### Marketplace v1
| Endpoint | Params | Response |
|---|---|---|
| `fetch_products_all.php` | — | Array of **Livestock** |
| `fetch_products_livestock.php` | optional `id` | Array of **Livestock** |
| `fetch_products_equipments.php` | optional `id` | Array of **Equipment** |
| `fetch_products.php` | `type_id`, `category_id`, `limit`, `except`, `is_random` | Array of Livestock **or** Equipment (depends on `type_id`) |
| `fetch_products_pictures.php` | `product_id` | Array of `{id, mkt_product_id, picture}` |
| `fetch_products_comments.php` | `product_id` | Array of `{id, name, description, mkt_product, date_time}` |
| `fetch_mkt_my_products.php` | `email_address` | Array of **MyProduct** |
| `insert_products.php` | `vendor`, `type_id`, `category_id`, `breed_id`, `name`, `description`, `quantity`, `price`, `currency` | `{code, message}` |
| `insert_products_with_images.php` | multipart: `file[]` + product fields | `{code, message}` |
| `insert_pictures_images.php` | multipart: `file[]`, `product_id` | `{code, message}` |
| `insert_product_comment.php` | `name`, `description`, `product_id` | `{code, message}` |
| `insert_products_order.php` | `buyer`, `order_items` (serialised list) | `{code, message}` |

Other V1 calls referenced: `get_extension_workers.php`, `save_token.php` (FCM token registration; LAN-only URL in code), `uploadfileApp.php`, `graphs.php` (a 000webhost URL for a product graph — dead/test).

---

## 14. Diagnosis / decision support service

Base **CMD**. Symptom-checker: user picks an animal type and symptoms → ranked candidate diseases.

### `update_2019_November/index.php` (POST, form) — `cmd` dispatcher
| `cmd` | Other params | Response |
|---|---|---|
| *(symptom list cmd)* | — | Array of **Symptom** `{id, symptom_name, nature}` |
| *(animal types cmd)* | — | Array of **AnimalType** |
| *(diagnose cmd)* | `signs_list`, `animal_type` | Array of **DiagnosisResult** `{id, name}` |
| *(disease detail cmd)* | `disease_id` | **DiagnosisDisease** `{id, name, description, category, prevention, treatment, time, symptoms:[Symptom]}` |
| *(doctors for disease cmd)* | `disease_id` | Array of **DiagnosisDiseaseDoctor** |

> The exact `cmd` string values for these five calls are supplied at runtime from the calling Activity and are not fixed literals in the interface; capture them from a network trace of the live app if you need them verbatim. Related literal command names seen elsewhere: `diagnosis`, `getDiseasesList`, `getAllSignsList`.

### `update_2019_December/index.php` (POST, form)
`cmd`, `type`, `full_name`, `picture`, `email`, `social_id` → **SocialUser** — social login/registration for the older app.

### Decision support (`decision_support_api` = `.../api/update_2019_October/`)
| Endpoint | Params | Response |
|---|---|---|
| `decision_support_offline.php` | — | `{decision_support, decision_support_animal, decision_support_options}` — full offline bundle, each a JSON **string** of an array |
| *(index, `cmd=getDecisionSupportForOneAnimal`)* | animal id | Decision-support entries for one animal |
| *(index, `cmd=getDecisionSupportOptionsForOneDecisionSupport`)* | decision-support id | Options for one entry |

Images: `https://jaguzalivestockug.com/mobileapp/dashboard2.1/admin/pictures/decision_support/<image>`.

### Sickness reporting (multipart upload)
`DoctorChatActivity` / `ReportSicknessActivity` upload media as multipart with `FOLDER`, `POST_ID` → `{status}`.

---

## 15. Legacy `cmd` command API

One endpoint, many commands. **`POST https://jaguzalivestockug.com/mobileapp/api/`** (the CMD base, path `/`), `application/x-www-form-urlencoded`, field **`cmd`** selects the operation. All other keys below are additional form fields. Response format is a JSON string; the client treats HTTP 200 as success and any other status as the literal string `"error"`.

`userId` (camelCase) and `user_id` (snake_case) both occur — the server evidently accepts both per command; use exactly what is listed.

### Account
| `cmd` | Params |
|---|---|
| `addUsers` | `username`, `email`, `phone`, `password`, `gender`, `gcm`, `country` |
| `login` | `username`, `country`, `password`, `gcm` |
| `logincode` | `userId`, `phone`, `pin` |
| `resendcode` | `phone` |
| `forgotPassword` | `email` |
| `changeEmailApp` | `phone`, `password`, `email` |
| `verifyEmail` | `email`, `acctype`, `role` |
| `updateUserInfo` | (EditProfile form fields) |
| `getDistricts` | `userId` |
| `AddDeviceGCM` | `gcm_key`, `user_id`, `acctype` (push-token registration) |
| `addFeedback` | `user_id`, `acctype`, `description`, `telephone` |
| `notifications_count` | `user_id` (+ `gcm`, `acctype`, `platform` from HomeActivity) → `{notification_count, status, categories, category_status}` |
| `load_notifications` | `user_id`, `page` |
| `addNotifications` | `user_id`, `user_role`, `content`, `flag`, `image` |
| `UploadImageApp` | `id`, `folder`, `img` (base64 image) |

### Farm, animals, records
| `cmd` | Params |
|---|---|
| `AddFarm` | `userId`, `farm_name`, `actual_location`, `district`, `longitude`, `latitude`, `image` |
| `getFarmDetails` | `userId`, `farm_id` |
| `SetMainFarm` | `userId`, `farm_id` |
| `AddAnimal` | `userId`, `farm_id`, `name`, `category_id`, `dob`, `tag_id`, `mother_animal`, `gender`, `breedval`, `weightval`, `image`, `deviceid`, `deviceid_temp`, `longitude`, `latitude` |
| `UpdateAnimal` | same as `AddAnimal` + `animalID` |
| `deleteAnimal` | `userId`, `acctype`, `animal_id`, `farm_id` |
| `getAnimalList` | `userId`, `farm_id`, `longitude`, `latitude` |
| `getAnimalDetails` | `userId`, `farm_id`, `animal_id` |
| `getAnimalBreedsForCategory` | `category_id` |
| `AddMilk` | `userId`, `farm_id`, `animal_id`, `amount`, `remarks`, `date` |
| `getMilkList` | `user_id`, `farm_id`, `start_date`, `end_date` |
| `AddGestation` | `userId`, `farm_id`, `animal_id`, `method`, `insemination_date`, `birth_date`, `notes`, `doctor_id` |
| `getGestationList` | `userId`, `farm_id` |
| `AddFarmExpense` | `userId`, `farm_id`, `expense`, `amount`, `description`, `date`, `image` |
| `getExpensesList` | `user_id`, `farm_id`, `start_date`, `end_date` |

### Marketplace (legacy listings)
| `cmd` | Params |
|---|---|
| `addMarket` | `userId`, `farm_id`, `title`, `location`, `price`, `content`, `post_type`, `image`, `telephone`, `animal_category_id`, `negotiable`, `longitude`, `latitude` |
| `getMarketProducts` | `self`, `userId`, `farm_id`, `longitude`, `latitude`, `page` |
| `getListingDetailsApp` | `userId`, `item_id`, `longitude`, `latitude` |
| `AddMarketComment` / `getMarketComments` | `userId`, `post_id`, `content` / `page` |
| `AddOffer` / `getProdOfferList` | `userId`, `listing_id`, `amount`, `phone` / `post_id`, `page` |
| `AddReview` | `userId`, `listing_id`, `content`, `good` |
| `viewBusinesses` | `user_id`, `page` |

### Health, community and support
| `cmd` | Params |
|---|---|
| `AddSicknessPost` | `userId`, `title`, `location`, `content`, `post_type`, `image`, `telephone`, `longitude`, `latitude` |
| `getSicknessPosts` | `self`, `userId`, `longitude`, `latitude`, `page` |
| `getAllCrimes` / `getAllCrimesMap` | `userId`, `longitude`, `latitude` *(command names are a leftover from a template app — they return sickness/community posts)* |
| `AddPostComment` / `getCommentsList` | `userId`, `post_id`, `content` / `page` |
| `AddnewPostLike` | `userId`, `post_id` |
| `getDoctors`, `getExtensionWorkers`, `getFacilities`, `getFarmingTips`, `getDiseasesList`, `getAllSignsList` | `userId`, `longitude`, `latitude` |
| `getMyQuestions` | `userId`, `acctype`, `longitude`, `latitude` |
| `diagnosis` | `userId`, `farm_id`, `signs_list`, `longitude`, `latitude` |
| `AddDoctorChat` | `userId`, `post_id`, `content`, `image`, `type`, `reply`, `replyID`, `type_to`, `type_from` |
| `getDoctorChatList` | `userId`, `post_id`, `page`, `type`, `type_to`, `type_from` |
| `getDoctorLastContacted` | `userId`, `page`, `type`, `longitude`, `latitude` |
| `DeleteChatMsg` | `userId`, `acctype`, `post_id` |
| `sendMsg` | `userId`, `receiver`, `content`, `rec_type`, `send_type`, `longitude`, `latitude` |
| `getDecisionSupportForOneAnimal` / `getDecisionSupportOptionsForOneDecisionSupport` | see §14 |

> This CMD API's **response shapes were not analysed** (the tasks pass raw response text to the UI thread, which parses it in each screen). To document them precisely, capture responses from the live server.

---

## 16. Push, chat, video, sensors

### Push notifications
- **FCM token registration:** CMD `AddDeviceGCM` (`gcm_key`, `user_id`, `acctype`). Farm-v2 users also store a `firebase_token` on the user record.
- **OneSignal** is also integrated (SDK 4.x); registration is done by the SDK to OneSignal's servers, not to the Jaguza backend.
- **Chat notifications (POST form, CMD):**
  - `update_2019_December/send_jaguza_chat_notification_to_admin.php` — `from`, `message`, `to`
  - `update_2019_December/FCM/send_jaguza_chat_notification_to_doctor.php` — same idea (currently only in commented-out code)
- **Incoming push payload** (`CustomFirebaseMessagingService`): `title`, `content`, optional image URL (`picture_url`), and an `activity` string (`"HOME"` …) that routes to a screen.

### Chat (Firebase Realtime Database)
The doctor/agent chat (`jaguzaagents/chats`) and app users are stored in **Firebase RTDB**, not the REST backend. Models: `FirebaseUser {id, key, first_name, last_name, picture, email, phone_number}`. You will need to recreate the RTDB structure or replace it with your own chat service. Chat messages can be translated via Google Translate (§17).

### Video call (OpenTok/TokBox + Heroku room)
- Session credentials come back as `OpenTokTokenResponse {apiKey, sessionId, token}`.
- Video-call rooms: `GET https://jaguza-call-center.herokuapp.com/room/{key}`.
- Call state is exchanged through Firebase as `VideoCall {key, state, user_first_name, user_surname, user_telephone, user_id, user_email, datetime, datetime_millis}`.

### Sensors
- **Location sensor (QR):** `http://livestock.jaguzafarm.com:8083/location_sensor/` (used by `QrScannerActivity` to resolve a scanned code to a device).
- **GPS/temperature tracker data** comes from **The Things Network** (LoRaWAN) storage integration (§17). `SensorRecord {batterypercent, dev_addr, dev_eui, device_id, gps, latitude, longitude, received_at, isValidData}`; temperature rows `{device, temperature, time}`.
- V2 side: animals carry `sensor_temp_id` and `sensor_location_id`; farm-side temperature endpoints in V1 (`fetch_real_time_temperature*.php`) are **dead** (§19).

---

## 17. Third-party services

| Service | Endpoint | Usage |
|---|---|---|
| OpenWeatherMap | `GET https://api.openweathermap.org/data/2.5/weather?lat=&lon=&appid=&cnt=17` and `.../weather?q=<city>&units=metric`, `.../forecast/daily` | Farm home weather; `weather[]`, `main`, `list[]`. Icons: `https://openweathermap.org/img/wn/<icon>@2x.png` |
| Google Translate v2 | `GET https://translation.googleapis.com/language/translate/v2/?key=&q=&source=&target=` | On-the-fly translation of content. Response: `{data:{translations:[{translatedText}]}, error}` |
| Google Directions | `https://maps.googleapis.com/maps/api/directions/` | Route to a doctor/market |
| Google Maps / Places / Sign-In | SDK | — |
| The Things Network (LoRaWAN) | `GET https://eu1.cloud.thethings.network/api/v3/as/applications/kal/packages/storage/uplink_message` with `Authorization: Bearer <token>` | Live tracker/temperature uplinks |
| Firebase | Realtime DB, FCM (SDK) | Chat, video-call signalling, push |
| OneSignal | SDK | Push |
| Segment | SDK (write key in `APP.java`) | Analytics |
| Flutterwave (Rave) | SDK (`PaymentHandlerActivity`) | Card / mobile-money payments |
| OpenTok (TokBox) | SDK | Video calls |
| Facebook Login | SDK | Social sign-in |

You will need your **own accounts and keys** for each of these; the keys in the source belong to the original owners (see §20).

---

## 18. Data models

Types are as sent on the wire: nearly everything is a **string**, including numbers and dates. `?` = nullable.

**User** — `id:int, first_name, surname, email, telephone, picture?, district?, firebase_token?`

**Farm** — `farm_id, name, type, country, district, county, village, farm_owner, timestamp, gps_lat, gps_lon, sync_status, status ("active"|…), farm_size, farm_boundary, role`

**FarmUser** — `first_name, surname, id, email, telephone, role`

**AnimalCategory** — `id, name, icon, picture, need_attention:int`

**AnimalBreed** — `breed_id, animal_type, breed_name, description, timestamp, synced, added_by`

**AnimalType** (V1) — `type_id, type_name, description, gestation, min_temp, max_temp, timestamp, synced, added_by, animal_image, icon`

**Animal (V2)** — `animal_ref, animal_type, animal_type_obj{type_id,type_name,description,min_temp,max_temp}, farm_id, tag_id, alias_name, breed_id, sex, description, birth_date, herd_id, produces_milk, animal_mother, animal_father, added_by, timestamp, sensor_id, price_tag, last_weight, sale_status, death_status, status, presence, photo, sync_status, breeding_stage, sensor_temp_id, sensor_location_id`

**Animal (V1 extra fields)** — `animal_types_name, herd_name, need_attention_id, need_attention_description, need_attention_date_time`

**Heat** — `id, detection_date, comment, animal_id, status, created_at, updated_at, animal:Animal`
**Insemination** — `id, animal_id, service_date, genetic_resource, breeding_method, heat_id, status, created_at, updated_at, animal:Animal`
**Pregnant** — `id, animal_ref, date, date_time, gestation_date, gestation_days, animal:Animal`
**Calving** — `id, animal_ref, date, number_of_calves, date_time, animal:Animal`
**Lactation / Rest** — `id, animal_ref, date, date_time, animal:Animal`
**Milking** — `id, animal_ref, period, date, date_time, quantity`
**MilkingRecordAnalysisForAnimal** — `date, total, milking_records:[Milking]`
**Feeding** — `feed_id, farm_id, feed_name, description, animal_type, animal_herd, quantity, units, feeding_datetime, timestamp, added_by, animal_type_name, added_by_user:User`
**Expenses** — `id, name, cost, payment_type, farm_id, expense_date, comment, date_recorded, added_by, user:User`
**Income** — `id:int, amount, source, date_time, farm_id`
**FarmHealthEvents** — `id:int, title, description, date_time, farm_id`
**NeedAttentionManual** — `id:int, reason, description, farm_id, animal_ref, date_time, state, animal:Animal, comment_resolved`

**Store** — `id, name, description, phone_number, email, country_id, mkt_store_type_id, gps_latitude, gps_longitude, picture, picture_cover, address, user_id, status, products:[StoreProducts]`
**StoreDataModel** — Store fields + `country, mkt_store_type` (names) and no `products`
**StoreProducts** — `id, animal_category_id, mkt_store_id, product_unit_id, animal_product_id, currency_id, name, description, quantity, price, old_price, animal_category, created_datetime, product_unit, animal_product, currency, currency_short_form, mkt_store:Store, pictures:[{id, path, mkt_store_product_id}]`
**StoreOrder** — `id, mkt_store_product_id, user_id, order_price, quantity, created_datetime, mkt_store_id, status, mkt_store_product:StoreProducts, user:User, mkt_store:StoreDataModel`
**MktRequests** — `id, user_id, animal_category_id, description, created_datetime, file, status, user:User, comments:[MktRequestsComments]`
**MktRequestsComments** — `id, user_id, comment, mkt_request_id, file, created_datetime, user:User`

**MARKET Category** — `id, title, description, icon`
**MARKET Product** — `id, name, description, unit_of_measure, stock_available, unit_price_seller, unit_price_buyer, unit_profit, seller_location, picture, product_status, user_id`
**ProductUpload** — Product + `category:Category, created_at`
**Cart** — `id, quantity, product:Product`
**Order** — `id, user_id, delivery_mode, delivery_fee, delivery_location, pickup_location, order_status, delivery_person_details, total_order_cost, total_profits, order_products:[{product, quantity}], created_at`
**MARKET Comment** — `id, user:User, comment, created_at`
**AdvertSlide** — `id, company_name, address, contact, email, web_link, additional_info, advert_image, status, created_at`
**Advert** — `id, picture, country, description, link, status, created_at, start_date, end_date, title, amount, name, contact, show_name, show_contact, transaction_id, days, views, actions, priority, remarks`
**AdvertPlan** — `id, day, amount, created_at`

**V1 Livestock / Equipment** — `id, vender_id, vender_address, type_id, category_id, breed_id?, name, description, quantity, price, currency_id, active, date, category_name, currency_name, picture`
**V1 OrderHistory** — `id, total_cost, order_date, order_state, order_state_name, mkt_buyer, mkt_order_products:[{id, order, product, no_of_products, name, price, currency_id, currency_name}]`

**SocialUser (CMD)** — `id, username, telephone, email, gender, status, role, acctype, password, last_seen, time, district, latitude, longitude, country_id, forgot_pass_token, token_time, email_verified, email_veri_token, sms_code, phone_verified` *(note: the server returns `password` and verification tokens to the client — do not copy that.)*

**Diagnosis** — `Symptom{id,symptom_name,nature}`, `DiagnosisResult{id,name}`, `DiagnosisDisease{id,name,description,category,prevention,treatment,time,symptoms:[Symptom]}`

---

## 19. Dead / unused endpoints

These strings exist **only in commented-out code** — the current client does not call them. Don't implement unless you want feature parity with an old version:

`fetch_add_animal_data`, `fetch_animal_herds`, `fetch_animal_herds_from_animal_type`, `fetch_animal_last_weight`, `fetch_animals_yearly_analysis_version_2`, `fetch_farm_home_version_3`, `fetch_farm_report`, `fetch_farms`, `fetch_health_events`, `fetch_health_events_with_date`, `fetch_module_animal_sale`, `fetch_module_animal_sale_by_date`, `fetch_module_farm_expenses`, `fetch_module_farm_expenses_by_date`, `fetch_module_farm_feeds`, `fetch_module_milk`, `fetch_module_milk_by_date`, `fetch_module_weight_version_2`, `fetch_products_order_history`, `fetch_real_time_temperature`, `fetch_real_time_temperature_last`, `fetch_real_time_temperature_limit`, `fetch_records_breeding`, `fetch_records_calving`, `fetch_records_health`, `fetch_records_heat`, `fetch_records_milk`, `fetch_records_pregnant`, `fetch_records_weight`, `frm_upload_certificate_of_ownership`, `send_jaguza_chat_notification_to_doctor`.

(An earlier summary of this project listed these as live; that was wrong — they are dead code.)

---

## 20. Rebuild notes and security findings

### Suggested build order
1. **Auth + user** (§3) — replace bare `user_id` trust with sessions/JWT.
2. **Farms, categories, animals** (§4, §5) — the core.
3. **Breeding, milking, feeding, health, finance** (§6–§8) and **reports** (§9).
4. **One marketplace** — the app has two (§10 and §11). §11 is the cleaner REST design; use it as the model.
5. **Adverts, weather, translation, push**.
6. Optional: diagnosis / decision support, doctor chat + video, sensors.

### Things to fix rather than copy
- **No authentication or authorisation** on any farm/market endpoint. Any caller who guesses a `farm_id`/`user_id` can read or write another farm's data.
- **Cleartext HTTP** on `livestock.jaguzafarm.com:8000/8080/8081/8083` and `usesCleartextTraffic="true"` in the manifest. Use HTTPS.
- **Passwords:** login/registration sends the password in the form body; the legacy `SocialUser` response includes `password`, `forgot_pass_token`, `sms_code`, `email_veri_token`. Never return these.
- **Sign-in code `300`** (temporary password) is a client-side convention — consider a proper "must change password" flag.
- **Inconsistent contracts:** `code` vs `status_code`, `userId` vs `user_id`, `animal_type_id` vs `animal_category_id`, string-typed numbers, JSON encoded *inside* JSON (`user`, `store`, `decision_support*`). Normalise in your API.
- **Typos baked into URLs** (`insermination`, `temprary`, `equipement`, `attension`) — you can fix them in a new backend but keep aliases if old apps must keep working.
- **Analytics and "need attention" logic** partly lives in the client; decide where it belongs.

### Secrets that were exposed in the source repo (rotate; never reuse)
The Android repository contains, in plaintext: the **release keystore** (`jaguzakey.jks`) and its passwords (in `app/build.gradle` and `details.txt`); logins for a YouTube/Gmail account and a TokBox account plus a **TokBox API secret**; a **Segment write key** (`APP.java`); a **Google Translate key**, a Google/YouTube developer key and **Google Maps keys** (in Java sources, `res/values/*.xml` and `google-services.json`; the OpenWeatherMap `appid` is not a literal in the code and is loaded from elsewhere); a **The Things Network bearer token** (`FarmTrackingActivity.kt`); Firebase config (`google-services.json`); and a Flutterwave/Rave integration. **These are deliberately not reproduced in this document.** Treat all of them as compromised, issue new ones for your system, and remove them from git history.

### What to capture from the live server to finish this document
Because the server code wasn't available, the following would need a network trace or the PHP source to be exact: the CMD API's response shapes (§15), the literal `cmd` names for the diagnosis calls (§14), the multipart file-field names for product/advert uploads, and validation/error codes beyond those listed in §2.
