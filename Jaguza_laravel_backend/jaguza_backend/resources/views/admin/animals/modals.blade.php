<!-- ===== Animal MODAL ===== -->
<div class="modal-overlay" id="animalsModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="animalsModalTitle">Add New Animal</h3>
            <button class="modal-close" onclick="closeModal('animalsModal')">&times;</button>
        </div>
        <form id="animalsForm" onsubmit="event.preventDefault(); saveAnimal();">
            <input type="hidden" id="animalsId">
            
                        <div class="form-group">
                <label>Name,type,breed,age,farm id <span class="required">*</span></label>
                <input type="text" id="animals_name,type,breed,age,farm_id" class="form-control" placeholder="Enter Name,type,breed,age,farm id" required>
            </div>
            
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="animalsSubmitBtn">Save Animal</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('animalsModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

@push('scripts')
<script>
    function resetAnimalForm() {
        document.getElementById('animalsId').value = '';
        document.getElementById('animals_name,type,breed,age,farm_id').value = '';

        document.getElementById('animalsModalTitle').textContent = 'Add New Animal';
        document.getElementById('animalsSubmitBtn').textContent = 'Save Animal';
    }
    
    function openAddAnimalModal() {
        resetAnimalForm();
        openModal('animalsModal');
    }
    
    function editAnimal(id) {
        showToast('Loading data...', 'info');
        fetch(`${API_URL}/animals/${id}`, { headers: getHeaders() })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const item = data.data;
                    document.getElementById('animalsId').value = item.id;
                    document.getElementById('animals_name,type,breed,age,farm_id').value = item.name,type,breed,age,farm_id || '';

                    document.getElementById('animalsModalTitle').textContent = 'Edit Animal';
                    document.getElementById('animalsSubmitBtn').textContent = 'Update Animal';
                    openModal('animalsModal');
                } else {
                    showToast(data.message || 'Error loading data', 'error');
                }
            })
            .catch(error => showToast('Error: ' + error.message, 'error'));
    }
    
    function deleteAnimal(id) {
        if (!confirm('⚠️ Are you sure you want to delete this Animal?')) return;
        fetch(`${API_URL}/animals/${id}`, { method: 'DELETE', headers: getHeaders() })
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
    
    function saveAnimal() {
        const id = document.getElementById('animalsId').value;
        const data = {
            name,type,breed,age,farm_id: document.getElementById('animals_name,type,breed,age,farm_id').value,

        };
        
        const url = id ? `${API_URL}/animals/${id}` : `${API_URL}/animals`;
        const method = id ? 'PUT' : 'POST';
        const submitBtn = document.getElementById('animalsSubmitBtn');
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
            submitBtn.textContent = id ? 'Update Animal' : 'Save Animal';
            if (data.success) {
                showToast(id ? 'Updated successfully!' : 'Created successfully!');
                closeModal('animalsModal');
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
            submitBtn.textContent = id ? 'Update Animal' : 'Save Animal';
            showToast('Network error: ' + error.message, 'error');
        });
    }
</script>
@endpush