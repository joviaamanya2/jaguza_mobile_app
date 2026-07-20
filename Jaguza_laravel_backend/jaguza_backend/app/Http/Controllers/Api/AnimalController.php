<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Animal;
use App\Models\SicknessReport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AnimalController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        
        if ($user->isAdmin()) {
            $animals = Animal::with(['farm', 'owner'])->get();
        } else {
            $animals = Animal::with(['farm', 'owner'])
                ->where('owner_id', $user->id)
                ->get();
        }

        return response()->json([
            'success' => true,
            'data' => $animals
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'identification_number' => 'required|unique:animals',
            'name' => 'nullable|string|max:255',
            'type' => 'required|in:' . implode(',', Animal::TYPES),
            'breed' => 'required|string|max:100',
            'gender' => 'required|in:' . implode(',', Animal::GENDERS),
            'age' => 'required|integer|min:0',
            'weight' => 'nullable|numeric|min:0',
            'health_status' => 'in:' . implode(',', Animal::HEALTH_STATUS),
            'farm_id' => 'required|exists:farms,id',
            'date_bought' => 'nullable|date',
            'purchase_price' => 'nullable|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $animal = Animal::create(array_merge(
            $request->all(),
            ['owner_id' => $request->user()->id]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Animal created successfully',
            'data' => $animal
        ], 201);
    }

    public function show($id)
    {
        $animal = Animal::with(['farm', 'owner', 'sicknessReports', 'vaccinations'])->find($id);
        
        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal not found'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $animal
        ]);
    }

    public function update(Request $request, $id)
    {
        $animal = Animal::find($id);
        
        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|max:255',
            'breed' => 'nullable|string|max:100',
            'weight' => 'nullable|numeric|min:0',
            'health_status' => 'in:' . implode(',', Animal::HEALTH_STATUS),
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $animal->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Animal updated successfully',
            'data' => $animal
        ]);
    }

    public function destroy($id)
    {
        $animal = Animal::find($id);
        
        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal not found'
            ], 404);
        }

        $animal->delete();

        return response()->json([
            'success' => true,
            'message' => 'Animal deleted successfully'
        ]);
    }

    public function updateHealth(Request $request, $id)
    {
        $animal = Animal::find($id);
        
        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'health_status' => 'required|in:' . implode(',', Animal::HEALTH_STATUS),
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

    public function healthHistory($id)
    {
        $animal = Animal::find($id);
        
        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal not found'
            ], 404);
        }

        $reports = SicknessReport::where('animal_id', $id)
            ->with(['doctor', 'reporter'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $reports
        ]);
    }
}