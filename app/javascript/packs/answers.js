$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).show()
    });
    $('.answers').on('click', '.mark-best-answer-link', function(e) {

    });
});

$(document).on('ajax:success', '.destroy-answer-link', function(e){
    let res = e.originalEvent.detail[0].notice;
    $('.answers').html(res);
    $(this).parentsUntil('.answers').remove();
});
