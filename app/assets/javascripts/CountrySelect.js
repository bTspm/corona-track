var CountrySelect = {
    init: function() {
        this.elements = {
            selectDropdown: $(".select2"),
        };
        return this;
    },

    bindEvents: function() {
        CountrySelect.initDropdown();
        CountrySelect.onSelection();
    },

    initDropdown: function() {
        CountrySelect.elements.selectDropdown.select2({
            placeholder: "Select a Country Ex: India",
            width: "resolve",
            templateResult: CountrySelect.formatCountry,
            templateSelection: CountrySelect.formatCountry
        });
    },

    formatCountry: function (country) {
        if (!country.id) {
            return country.text;
        }
        return $(
            '<span><i class="flag-icon flag-icon-' +
            $(country.element).data("alpha2").toLowerCase() +
            '"></i> ' +
            country.text +
            "</span>"
        );
    },

    onSelection: function(){
        $('.select2').on('select2:select', function (e) {
            var data = e.params.data.id;
            var path = argumentsFromServer.returnPath + '?code=' + data;
            window.location = path;
        });
    }
};
