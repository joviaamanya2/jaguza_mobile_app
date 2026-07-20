<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\GestationRecord;
use App\Models\Animal;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class GestationController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => GestationRecord::with('animal')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'animal_id' => 'required|exists:animals,id',
            'mating_date' => 'required|date',
            'expected_delivery_date' => 'required|date',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $gestation = GestationRecord::create(array_merge(
            $request->all(),
            ['is_active' => true, 'is_verified' => true]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Gestation record added successfully',
            'data' => $gestation
        ], 201);
    }

    public function show($id)
    {
        $gestation = GestationRecord::with('animal')->find($id);
        if (!$gestation) {
            return response()->json(['success' => false, 'message' => 'Record not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $gestation]);
    }

    public function update(Request $request, $id)
    {
        $gestation = GestationRecord::find($id);
        if (!$gestation) {
            return response()->json(['success' => false, 'message' => 'Record not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'mating_date' => 'required|date',
            'expected_delivery_date' => 'required|date',
            'actual_delivery_date' => 'nullable|date',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $gestation->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Gestation record updated successfully',
            'data' => $gestation
        ]);
    }

    public function destroy($id)
    {
        $gestation = GestationRecord::find($id);
        if (!$gestation) {
            return response()->json(['success' => false, 'message' => 'Record not found'], 404);
        }
        $gestation->delete();
        return response()->json(['success' => true, 'message' => 'Record deleted successfully']);
    }
}
