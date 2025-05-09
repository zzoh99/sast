// dragDrop.js

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function removeNode(node) {
    node.parentNode.removeChild(node);
}

function drop(ev) {
    ev.preventDefault();
    ev.stopPropagation();

    if (!ev.target.classList.contains('drop-area')) {
        return false;
    }

    var data = ev.dataTransfer.getData("text");
    var originalNode = document.getElementById(data);
    if (!originalNode) {
        return false;
    }

    // Check if the node is already dropped
    if (ev.target.contains(originalNode)) {
        return false;
    }

    var nodeCopy = originalNode.cloneNode(true);
    nodeCopy.id = "chip" + new Date().getTime(); // unique ID to avoid duplicates

    ev.target.appendChild(nodeCopy);
    ev.target.classList.remove('drag-over');

    checkAndAddNewDropZone();
    addCloseIconEvent();

    initializeDragAndDrop(); // 재설정 호출

    return false;
}

function dragEnter(ev) {
    if (ev.target.classList.contains('drop-area')) {
        ev.target.classList.add('drag-over');
    }
}

function dragLeave(ev) {
    if (ev.target.classList.contains('drop-area')) {
        ev.target.classList.remove('drag-over');
    }
}

function checkAndAddNewDropZone() {
    const innerWraps = document.querySelectorAll('#divDrop > .inner-wrap');
    let allFilled = true;

    innerWraps.forEach(innerWrap => {
        const dropArea = innerWrap.querySelector('.drop-area');
        if (!dropArea || dropArea.children.length === 0) {
            allFilled = false;
        }
    });

    if (allFilled) {
        const newDropZone = document.createElement('div');
        newDropZone.classList.add('inner-wrap');

        const innerDiv = document.createElement('div');
        innerDiv.classList.add('day-unit');
        innerDiv.textContent = (innerWraps.length + 1) + '일';
        newDropZone.appendChild(innerDiv);

        const dropArea = document.createElement('div');
        dropArea.id = 'divDrop' + (innerWraps.length + 1);
        dropArea.classList.add('drop-area');
        dropArea.ondrop = drop;
        dropArea.ondragover = allowDrop;
        newDropZone.appendChild(dropArea);

        document.getElementById('divDrop').appendChild(newDropZone);
    }
}

function addCloseIconEvent() {
    document.querySelectorAll('.mdi-ico').forEach(icon => {
        icon.removeEventListener('click', handleIconClick);
        icon.addEventListener('click', handleIconClick);
    });
}

function handleIconClick(ev) {
    ev.stopPropagation();
    const chip = ev.target.closest('.attend-chip');
    if (chip) {
        removeNode(chip);
        initializeDragAndDrop(); // chip을 삭제한 후에도 재설정 호출
    }
}

function initializeDragAndDrop() {
    // Remove existing event listeners before adding new ones
    document.querySelectorAll('.drop-area').forEach(col => {
        col.removeEventListener('dragenter', dragEnter);
        col.removeEventListener('dragleave', dragLeave);
        col.removeEventListener('drop', drop);
        col.removeEventListener('dragover', allowDrop);

        col.addEventListener('dragenter', dragEnter);
        col.addEventListener('dragleave', dragLeave);
        col.addEventListener('drop', drop);
        col.addEventListener('dragover', allowDrop);
    });

    document.querySelectorAll('.attend-chip').forEach(chip => {
        chip.setAttribute('draggable', 'true');
        chip.removeEventListener('dragstart', drag); // Remove existing listener
        chip.addEventListener('dragstart', drag); // Add new listener
    });

    addCloseIconEvent();
}

document.addEventListener('DOMContentLoaded', initializeDragAndDrop);
