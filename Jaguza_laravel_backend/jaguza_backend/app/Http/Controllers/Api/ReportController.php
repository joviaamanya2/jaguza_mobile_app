<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SicknessReport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReportController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => SicknessReport::with(['animal', 'reporter', 'doctor.user'])->get()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'animal_id' => 'required|exists:animals,id',
            'symptoms' => 'required|string',
            'reported_by' => 'required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $report = SicknessReport::create([
            'report_id' => 'SR-' . rand(10000, 99999),
            'animal_id' => $request->animal_id,
            'symptoms' => $request->symptoms,
            'reported_by' => $request->reported_by,
            'doctor_id' => $request->doctor_id,
            'status' => 'open',
            'reported_date' => now(),
            'notes' => $request->notes,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Sickness report created successfully',
            'data' => SicknessReport::with(['animal', 'reporter', 'doctor.user'])->find($report->id)
        ], 201);
    }

    public function show($id)
    {
        $report = SicknessReport::with(['animal', 'reporter', 'doctor.user'])->find($id);
        if (!$report) {
            return response()->json(['success' => false, 'message' => 'Report not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $report]);
    }

    public function update(Request $request, $id)
    {
        $report = SicknessReport::find($id);
        if (!$report) {
            return response()->json(['success' => false, 'message' => 'Report not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'symptoms' => 'required|string',
            'status' => 'required|in:' . implode(',', SicknessReport::STATUS),
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $report->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Report updated successfully',
            'data' => SicknessReport::with(['animal', 'reporter', 'doctor.user'])->find($id)
        ]);
    }

    public function destroy($id)
    {
        $report = SicknessReport::find($id);
        if (!$report) {
            return response()->json(['success' => false, 'message' => 'Report not found'], 404);
        }

        $report->delete();
        return response()->json(['success' => true, 'message' => 'Report deleted successfully']);
    }

    public function assignDoctor(Request $request, $id)
    {
        $report = SicknessReport::findOrFail($id);
        $validator = Validator::make($request->all(), [
            'doctor_id' => 'required|exists:doctors,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $report->update([
            'doctor_id' => $request->doctor_id,
            'status' => 'treating'
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Doctor assigned successfully',
            'data' => $report
        ]);
    }

    public function resolve(Request $request, $id)
    {
        $report = SicknessReport::findOrFail($id);
        $report->update([
            'status' => 'resolved',
            'resolved_date' => now(),
            'diagnosis' => $request->diagnosis ?? 'Treated',
            'treatment' => $request->treatment ?? 'Administered medicine',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Report marked as resolved',
            'data' => $report
        ]);
    }

    public function stats()
    {
        return response()->json([
            'success' => true,
            'stats' => [
                'open' => SicknessReport::where('status', 'open')->count(),
                'treating' => SicknessReport::where('status', 'treating')->count(),
                'resolved' => SicknessReport::where('status', 'resolved')->count(),
            ]
        ]);
    }
}
