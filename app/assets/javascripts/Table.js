var Table = {
    initTable: function () {
        $('#countries-data-table').DataTable({
            bInfo: false,
            fixedColumns: true,
            order: [[4, "desc"]],
            paging: false,
            scrollCollapse: true,
            scrollY: 350,
            scrollX: true,
        });
    },
};
