function confirmJob(button, id){
      const tr = button.closest('tr');
      if(!tr) return;
      const statusEl = tr.querySelector('.status');
      if(statusEl){
        statusEl.className = 'status ok';
        statusEl.textContent = 'Đã duyệt';
      }
      button.outerHTML = '<button class="btn danger" onclick="cancelConfirm(this,'+id+')">Hủy xác nhận</button>';
    }

    function cancelConfirm(button, id){
      const tr = button.closest('tr');
      if(!tr) return;
      const statusEl = tr.querySelector('.status');
      if(statusEl){
        statusEl.className = 'status pending';
        statusEl.textContent = 'Chưa duyệt';
      }
      button.outerHTML = '<button class="btn confirm" onclick="confirmJob(this,'+id+')">Xác nhận</button>';
    }