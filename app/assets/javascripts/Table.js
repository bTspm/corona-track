var Table = {
    initTable: function () {
        $('#countries-data-table').DataTable({
            bInfo: false,
            order: [[5, "desc"]],
            paging: false,
            scrollCollapse: true,
            scrollY: "90vh",
            scrollX: true,
        });
    },
};
