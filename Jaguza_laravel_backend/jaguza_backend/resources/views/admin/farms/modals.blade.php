<!-- ===== Farm MODAL ===== -->
<div class="modal-overlay" id="farmsModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="farmsModalTitle">Add New Farm</h3>
            <button class="modal-close" onclick="closeModal('farmsModal')">&times;</button>
        </div>
        <form id="farmsForm" onsubmit="event.preventDefault(); saveFarm();">
            <input type="hidden" id="farmsId">
            
                        <div class="form-group">
                <label>Name,location,owner id,size <span class="required">*</span></label>
                <input type="text" id="farms_name,location,owner_id,size" class="form-control" placeholder="Enter Name,location,owner id,size" required>
            </div>
            
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="farmsSubmitBtn">Save Farm</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('farmsModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

@push('scripts')
<script>
    function resetFarmForm() {
        document.getElementById('farmsId').value = '';
        document.getElementById('farms_name,location,owner_id,size').value = '';

        document.getElementById('farmsModalTitle').textContent = 'Add New Farm';
        document.getElementById('farmsSubmitBtn').textContent = 'Save Farm';
    }
    
    function openAddFarmModal() {
        resetFarmForm();
        openModal('farmsModal');
    }
    
    function editFarm(id) {
        showToast('Loading data...', 'info');
        fetch(`${API_URL}/farms/${id}`, { headers: getHeaders() })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const item = data.data;
                    document.getElementById('farmsId').value = item.id;
                    document.getElementById('farms_name,location,owner_id,size').value = item.name,location,owner_id,size || '';

                    document.getElementById('farmsModalTitle').textContent = 'Edit Farm';
                    document.getElementById('farmsSubmitBtn').textContent = 'Update Farm';
                    openModal('farmsModal');
                } else {
                    showToast(data.message || 'Error loading data', 'error');
                }
            })
            .catch(error => showToast('Error: ' + error.message, 'error'));
    }
    
    function deleteFarm(id) {
        if (!confirm('⚠️ Are you sure you want to delete this Farm?')) return;
        fetch(`${API_URL}/farms/${id}`, { method: 'DELETE', headers: getHeaders() })
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
    
    function saveFarm() {
        const id = document.getElementById('farmsId').value;
        const data = {
            name,location,owner_id,size: document.getElementById('farms_name,location,owner_id,size').value,

        };
        
        const url = id ? `${API_URL}/farms/${id}` : `${API_URL}/farms`;
        const method = id ? 'PUT' : 'POST';
        const submitBtn = document.getElementById('farmsSubmitBtn');
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
            submitBtn.textContent = id ? 'Update Farm' : 'Save Farm';
            if (data.success) {
                showToast(id ? 'Updated successfully!' : 'Created successfully!');
                closeModal('farmsModal');
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
            submitBtn.textContent = id ? 'Update Farm' : 'Save Farm';
            showToast('Network error: ' + error.message, 'error');
        });
    }
</script>
@endpush