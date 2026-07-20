@extends('admin.layouts.app')

@section('title', 'Farms')

@section('content')
<div class="section-heading">
    <h2><i class="fas fa-warehouse" style="color:#fd7e14;margin-right:8px;"></i>Farms</h2>
    <button class="btn btn-primary" onclick="openAddFarmModal()">+ Add Farm</button>
</div>

<div class="card">
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                                        <th>Name,location,owner id,size</th>

                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($farms as $item)
                <tr>
                    <td>{{ $loop->iteration }}</td>
                                        <td>{{ $item->name,location,owner_id,size ?? 'N/A' }}</td>

                    <td>
                        <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;" onclick="editFarm($item->id)">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;color:var(--red);" onclick="deleteFarm($item->id)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="100%" style="text-align:center;padding:40px;color:#6a7a8a;">
                        <i class="fas fa-warehouse" style="font-size:40px;display:block;margin-bottom:10px;color:#c8d0d8;"></i>
                        No Farms found. Click the "Add Farm" button to create one.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection

@section('modals')
@include('admin.farms.modals')
@endsection