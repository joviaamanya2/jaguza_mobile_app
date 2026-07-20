<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\VaccinationRecord;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class VaccinationController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => VaccinationRecord::with(['animal', 'administeredBy'])->get()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'animal_id' => 'required|exists:animals,id',
            'vaccine_name' => 'required|string|max:255',
            'vaccine_type' => 'nullable|string|max:100',
            'administered_by' => 'nullable|exists:doctors,id',
            'administered_date' => 'required|date',
            'next_due_date' => 'nullable|date|after_or_equal:administered_date',
            'batch_number' => 'nullable|string|max:50',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $vaccination = VaccinationRecord::create(array_merge(
            $request->all(),
            ['is_completed' => true]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Vaccination record added successfully',
            'data' => $vaccination
        ], 201);
    }

    public function show($id)
    {
        $vaccination = VaccinationRecord::with(['animal', 'administeredBy'])->find($id);
        if (!$vaccination) {
            return response()->json(['success' => false, 'message' => 'Record not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $vaccination]);
    }

    public function update(Request $request, $id)
    {
        $vaccination = VaccinationRecord::find($id);
        if (!$vaccination) {
            return response()->json(['success' => false, 'message' => 'Record not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'vaccine_name' => 'required|string|max:255',
            'administered_date' => 'required|date',
            'next_due_date' => 'nullable|date|after_or_equal:administered_date',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $vaccination->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Vaccination record updated successfully',
            'data' => $vaccination
        ]);
    }

    public function destroy($id)
    {
        $vaccination = VaccinationRecord::find($id);
        if (!$vaccination) {
            return response()->json(['success' => false, 'message' => 'Record not found'], 404);
        }
        $vaccination->delete();
        return response()->json(['success' => true, 'message' => 'Record deleted successfully']);
    }
}
