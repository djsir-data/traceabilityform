$(document).ready(function () {
  // Hide/disable content by default
  $(".advancedContent").hide();
  $(".uncertaintyContent").hide();
  $('a[data-toggle="tab"]').not(".active").addClass("disabled");
  $("#btn_prev").hide();

  // Array of tabs
  var tabList = [];
  $('a[data-toggle="tab"]').each(function (e) {
    tabList.push($(this).attr("data-value"));
  });

  // Tab tracker
  var activeTab = "start";
  $('a[data-toggle="tab"]').on("shown.bs.tab", function (e) {
    activeTab = e.target.getAttribute("data-value");
  });

  // Nav button enable/disable
  $('a[data-toggle="tab"]').on("shown.bs.tab", function (e) {
    targetTab = e.target.getAttribute("data-value");

    if (targetTab != "start") {
      $("#btn_prev").show();
    } else {
      $("#btn_prev").hide();
    }

    if (targetTab != "results") {
      $("#btn_next").show();
    } else {
      $("#btn_next").hide();
    }
  });

  // Navbar tab switch validation
  $('a[data-toggle="tab"]').on("show.bs.tab", function (e) {
    var inputs = $("input:visible");
    inputs.removeClass("is-invalid");

    var allValid = true;
    inputs.each(function (index, value) {
      allValid = allValid & ($(value).val().length > 0);
    });

    if (!Boolean(allValid)) {
      e.preventDefault();
      e.stopPropagation();

      inputs.each(function (index, value) {
        if ($(value).val().length == 0) {
          this.classList.add("is-invalid");
        }
      });
    }
  });

  // Forward navigation
  $("#btn_next").click(function (e) {
    if (activeTab != "results") {
      var inputs = $("input:visible");
      inputs.removeClass("is-invalid");

      var allValid = true;
      inputs.each(function (index, value) {
        allValid = allValid & ($(value).val().length > 0);
      });

      inputs.each(function (index, value) {
        if ($(value).val().length == 0) {
          this.classList.add("is-invalid");
        }
      });

      if (Boolean(allValid)) {
        const targetTabIndex = tabList.indexOf(activeTab) + 1;
        var targetTab = $('a[data-value="' + tabList[targetTabIndex] + '"]');
        targetTab.removeClass("disabled");
        targetTab.tab("show");
      }
    }
  });

  // Backwards navigation
  $("#btn_prev").click(function (e) {
    if (activeTab != "start") {
      var inputs = $("input:visible");
      inputs.removeClass("is-invalid");

      var allValid = true;
      inputs.each(function (index, value) {
        allValid = allValid & ($(value).val().length > 0);
      });

      inputs.each(function (index, value) {
        if ($(value).val().length == 0) {
          this.classList.add("is-invalid");
        }
      });

      if (Boolean(allValid)) {
        const targetTabIndex = tabList.indexOf(activeTab) - 1;
        const targetTab = tabList[targetTabIndex];
        $('a[data-value="' + targetTab + '"]').tab("show");
      }
    }
  });

  // Advanced and uncertainty content
  var advancedContent = document.getElementById("switch_advanced");
  var uncertaintyContent = document.getElementById("switch_uncertainty");

  $("#switch_advanced").click(function () {
    if (advancedContent.checked) {
      $(".basicContent").slideUp();
      $(".advancedContent").slideDown();
    } else {
      $(".basicContent").slideDown();
      $(".advancedContent").slideUp();
    }
  });

  $("#switch_uncertainty").click(function () {
    if (uncertaintyContent.checked) {
      $(".uncertaintyContent").slideDown();
    } else {
      $(".uncertaintyContent").slideUp();
    }
  });
});