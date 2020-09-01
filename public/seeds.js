$(function() {
  var asCurrency = function(x) {
    return Math.round(x).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
  },
  fromCurrency = function(x) {
    return parseInt(x.replace(/\,+/g, ""))
  }
  recomputeGiving = function() {
    var percentage  = parseFloat($('#seedsCalculator input[name=percentage]').val()),
        salary      = fromCurrency($('#seedsCalculator input[name=salary]').val()),
        annual      = (percentage / 100.0) * salary,
        weekly      = annual / 52,
        monthly     = annual / 12,
        quarterly   = annual / 4,
        bi_annual   = annual / 2;
    if (isNaN(annual)) {
      $('#seedsCalculator input[name=annual_giving]').val(null)
      $('#weekly').val(null)
      $('#monthly').val(null)
      $('#quarterly').val(null)
      $('#biAnnually').val(null)
    } else {
      $('#seedsCalculator input[name=annual_giving]').val(asCurrency(annual))
      $('#weekly').val(asCurrency(weekly))
      $('#monthly').val(asCurrency(monthly))
      $('#quarterly').val(asCurrency(quarterly))
      $('#biAnnually').val(asCurrency(bi_annual))
    }
  },
  formatNumbers = function() {
    var percentage = parseFloat($('#seedsCalculator input[name=percentage]').val()),
        salary = fromCurrency($('#seedsCalculator input[name=salary]').val());
    if (!isNaN(percentage)) {
      $('#seedsCalculator input[name=percentage]').val('' + percentage + '%')
    }
    if (!isNaN(salary)) {
      $('#seedsCalculator input[name=salary]').val(asCurrency(salary))
    }
  };
  $('#seedsCalculator input').keyup(recomputeGiving)
  $('#seedsCalculator input').change(formatNumbers)
})
