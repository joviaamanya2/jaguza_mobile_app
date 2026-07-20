<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Animal;
use App\Models\Farm;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AdminAnimalController extends Controller
{
    public function index()
    {
        $animals = Animal::with(['farm', 'owner'])->orderBy('created_at', 'desc')->paginate(20);
        $farms = Farm::all();
        return view('admin.animals.index', compact('animals', 'farms'));
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'identification_number' => 'required|unique:animals',
            'name' => 'nullable|string|max:255',
            'type' => 'required|in:cattle,goat,sheep,pig,poultry,rabbit,horse,other',
            'breed' => 'required|string|max:100',
            'gender' => 'required|in:male,female',
            'age' => 'required|integer|min:0',
            'weight' => 'nullable|numeric|min:0',
            'health_status' => 'required|in:healthy,sick,treatment,quarantine,recovering,critical',
            'farm_id' => 'required|exists:farms,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $animal = Animal::create([
            'identification_number' => $request->identification_number,
            'name' => $request->name,
            'type' => $request->type,
            'breed' => $request->breed,
            'gender' => $request->gender,
            'age' => $request->age,
            'weight' => $request->weight,
            'health_status' => $request->health_status,
            'farm_id' => $request->farm_id,
            'owner_id' => auth()->id(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Animal added successfully',
            'data' => $animal
        ]);
    }

    public function show($id)
    {
        $animal = Animal::with(['farm', 'owner', 'sicknessReports', 'vaccinations'])->findOrFail($id);
        return response()->json([
            'success' => true,
            'data' => $animal
        ]);
    }

    public function update(Request $request, $id)
    {
        $animal = Animal::findOrFail($id);
        
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|max:255',
            'breed' => 'required|string|max:100',
            'weight' => 'nullable|numeric|min:0',
            'health_status' => 'required|in:healthy,sick,treatment,quarantine,recovering,critical',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $animal->update($request->only(['name', 'breed', 'weight', 'health_status', 'notes']));

        return response()->json([
            'success' => true,
            'message' => 'Animal updated successfully',
            'data' => $animal
        ]);
    }

    public function destroy($id)
    {
        $animal = Animal::findOrFail($id);
        $animal->delete();

        return response()->json([
            'success' => true,
            'message' => 'Animal deleted successfully'
        ]);
    }

    public function updateHealth(Request $request, $id)
    {
        $animal = Animal::findOrFail($id);
        
        $validator = Validator::make($request->all(), [
            'health_status' => 'required|in:healthy,sick,treatment,quarantine,recovering,critical',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $animal->update(['health_status' => $request->health_status]);

        return response()->json([
            'success' => true,
            'message' => 'Health status updated successfully',
            'data' => $animal
        ]);
    }
}