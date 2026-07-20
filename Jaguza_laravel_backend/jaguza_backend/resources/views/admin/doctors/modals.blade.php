<!-- ===== Doctor MODAL ===== -->
<div class="modal-overlay" id="doctorsModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="doctorsModalTitle">Add New Doctor</h3>
            <button class="modal-close" onclick="closeModal('doctorsModal')">&times;</button>
        </div>
        <form id="doctorsForm" onsubmit="event.preventDefault(); saveDoctor();">
            <input type="hidden" id="doctorsId">
            
                        <div class="form-group">
                <label>Name,specialization,location,phone,license number <span class="required">*</span></label>
                <input type="text" id="doctors_name,specialization,location,phone,license_number" class="form-control" placeholder="Enter Name,specialization,location,phone,license number" required>
            </div>
            
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="doctorsSubmitBtn">Save Doctor</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('doctorsModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

@push('scripts')
<script>
    function resetDoctorForm() {
        document.getElementById('doctorsId').value = '';
        document.getElementById('doctors_name,specialization,location,phone,license_number').value = '';

        document.getElementById('doctorsModalTitle').textContent = 'Add New Doctor';
        document.getElementById('doctorsSubmitBtn').textContent = 'Save Doctor';
    }
    
    function openAddDoctorModal() {
        resetDoctorForm();
        openModal('doctorsModal');
    }
    
    function editDoctor(id) {
        showToast('Loading data...', 'info');
        fetch(`${API_URL}/doctors/${id}`, { headers: getHeaders() })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const item = data.data;
                    document.getElementById('doctorsId').value = item.id;
                    document.getElementById('doctors_name,specialization,location,phone,license_number').value = item.name,specialization,location,phone,license_number || '';

                    document.getElementById('doctorsModalTitle').textContent = 'Edit Doctor';
                    document.getElementById('doctorsSubmitBtn').textContent = 'Update Doctor';
                    openModal('doctorsModal');
                } else {
                    showToast(data.message || 'Error loading data', 'error');
                }
            })
            .catch(error => showToast('Error: ' + error.message, 'error'));
    }
    
    function deleteDoctor(id) {
        if (!confirm('⚠️ Are you sure you want to delete this Doctor?')) return;
        fetch(`${API_URL}/doctors/${id}`, { method: 'DELETE', headers: getHeaders() })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Deleted successfully!');
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showToast(data.message || 'Error deleting', 'error');
                }
            })
            .catch(error => showToast('Error: ' + error.message, 'error'));
    }
    
    function saveDoctor() {
        const id = document.getElementById('doctorsId').value;
        const data = {
            name,specialization,location,phone,license_number: document.getElementById('doctors_name,specialization,location,phone,license_number').value,

        };
        
        const url = id ? `${API_URL}/doctors/${id}` : `${API_URL}/doctors`;
        const method = id ? 'PUT' : 'POST';
        const submitBtn = document.getElementById('doctorsSubmitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Saving...';
        
        fetch(url, { 
            method: method, 
            headers: getHeaders(), 
            body: JSON.stringify(data) 
        })
        .then(response => response.json())
        .then(data => {
            submitBtn.disabled = false;
            submitBtn.textContent = id ? 'Update Doctor' : 'Save Doctor';
            if (data.success) {
                showToast(id ? 'Updated successfully!' : 'Created successfully!');
                closeModal('doctorsModal');
                setTimeout(() => location.reload(), 1000);
            } else {
                let errors = '';
                if (data.errors) {
                    Object.values(data.errors).forEach(error => errors += error + '
');
                    showToast(errors, 'error');
                } else {
                    showToast(data.message || 'Error saving', 'error');
                }
            }
        })
        .catch(error => {
            submitBtn.disabled = false;
            submitBtn.textContent = id ? 'Update Doctor' : 'Save Doctor';
            showToast('Network error: ' + error.message, 'error');
        });
    }
</script>
@endpush