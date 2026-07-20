@extends('admin.layouts.app')

@section('title', 'Animals')

@section('content')
<div class="section-heading">
    <h2><i class="fas fa-horse" style="color:#4a148c;margin-right:8px;"></i>Animals</h2>
    <button class="btn btn-primary" onclick="openAddAnimalModal()">+ Add Animal</button>
</div>

<div class="card">
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                                        <th>Name,type,breed,age,farm id</th>

                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($animals as $item)
                <tr>
                    <td>{{ $loop->iteration }}</td>
                                        <td>{{ $item->name,type,breed,age,farm_id ?? 'N/A' }}</td>

                    <td>
                        <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;" onclick="editAnimal($item->id)">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;color:var(--red);" onclick="deleteAnimal($item->id)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="100%" style="text-align:center;padding:40px;color:#6a7a8a;">
                        <i class="fas fa-horse" style="font-size:40px;display:block;margin-bottom:10px;color:#c8d0d8;"></i>
                        No Animals found. Click the "Add Animal" button to create one.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection

@section('modals')
@include('admin.animals.modals')
@endsection