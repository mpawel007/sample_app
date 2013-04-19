var max_characters_count = 140;
var min_characters_count = 0;
var current_characters_count = max_characters_count;

$(document).ready( function(){

	if( $("#micropost_content").val().length > 0 ){
		current_characters_count -= $("#micropost_content").val().length
		if( current_characters_count < 0){
			current_characters_count = 0;
			$("#micropost_content_count").val( $("#micropost_content_count").val().substr(min_characters_count, max_characters_count ) );
		}
	}
	$("#micropost_content_count").html( current_characters_count );

	$("#micropost_content").on("keyup", function(){
		var length = $(this).val().length;
		if( length < min_characters_count ){
			current_characters_count = max_characters_count;
		}
		else if( length > max_characters_count ){
			current_characters_count = min_characters_count;
			$(this).val( $(this).val().substr( min_characters_count, max_characters_count ) );
		}
		else{
			current_characters_count = max_characters_count - length;
		}
		$("#micropost_content_count").html( current_characters_count );
	});

});
