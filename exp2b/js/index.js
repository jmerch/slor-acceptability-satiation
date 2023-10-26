var order = 1;

// I don't know why this exists, but it seems to work
// and we make use of it
var shuffle = function (array) {

	var currentIndex = array.length;
	var temporaryValue, randomIndex;

	// While there remain elements to shuffle...
	while (0 !== currentIndex) {
		// Pick a remaining element...
		randomIndex = Math.floor(Math.random() * currentIndex);
		currentIndex -= 1;

		// And swap it with the current element.
		temporaryValue = array[currentIndex];
		array[currentIndex] = array[randomIndex];
		array[randomIndex] = temporaryValue;
	}

	return array;

};

var repeatStim = function (str1, str2) {
	array1 = str1.trim().split(" ");
	array2 = str2.trim().split(" ");
	for (var i = 0; i < array1.length; i++) {
		array1[i] = array1[i].toLowerCase();
	}
	for (var i = 0; i < array2.length; i++) {
		array2[i] = array2[i].toLowerCase();
	}
	//array1.sort();
	//array2.sort();
	return array1.toString() === array2.toString();
};


// experiment parameters

num_exposure_items = 55; // how many target items in the exposure phase?
//num_test_items = 10; // how many target items in the test phase?
//num_unique_lex_items = num_exposure_items + num_test_items;
//num_fillers = 11; /* half the number of target items. Each type of filler
                //  will have this many items */
block_size = 11;
//num_exposure_blocks = num_exposure_items/2; // 2 target items per block
//num_test_blocks = num_test_items/2; // 2 target items per block

// choose an experimental group
// match sees the same condition throughout
// mismatch sees different conditions on exposure and test
//experiment_group = shuffle(["match", "mismatch", "control"])[0];

// choose experimental condition
//shuffled_conditions = ["SUBJ", "WH"]; //shuffle(["SUBJ","WH"]);
//test_cond = shuffled_conditions[0];
//exposure_cond = shuffled_conditions[1];

//if(experiment_group == "match"){
  //exposure_cond = test_cond;
//}
//if(experiment_group == "control"){
  //exposure_cond = "POLAR";
//}

//console.log(experiment_group);
//console.log("exp", exposure_cond);
//console.log("test", test_cond);

// sort items into pools we can sample from
// only take <num_unique_lex_items> total items from stimuli list

// in the 'match' group, these will have the same items
//exposure_pool = all_stimuli.filter(function (e){
//  return e.condition == exposure_cond && e.lex_items < num_unique_lex_items+1;
//});
//test_pool = all_stimuli.filter(function (e){
  //return e.condition == test_cond && e.lex_items < num_unique_lex_items+1;
//});

// split data into phases
// phases are disjoint sets of lexical items
//exposure_stimuli = shuffle(exposure_pool).slice(0,num_exposure_items);
//test_stimuli = test_pool.filter(function (t){
  // t.lex_items not in exposure_stimuli
//  return !(exposure_stimuli.find(e => e.lex_items == t.lex_items));
//});

// do the same with fillers

//fillers_gram = all_stimuli.filter(function (e){
//  return e.condition == "FILL" && e.lex_items < num_fillers+101;
//});
//fillers_ungram = all_stimuli.filter(function (e){
//  return e.condition == "UNGRAM" && e.lex_items < num_fillers+117;
//});

//fillers_gram = shuffle(fillers_gram);
//fillers_ungram = shuffle(fillers_ungram);


// split phases into blocks
// each block has two target items, one grammatical filler,
// and one ungrammatical filler
/*exposure_blocks = []; // a list of lists of item objects
for(var i = 0; i < num_exposure_blocks; i++){
  block = [exposure_stimuli.pop(), exposure_stimuli.pop(), fillers_gram.pop(), fillers_ungram.pop()];
  block = shuffle(block);
  exposure_blocks.push(block);
}

test_blocks = []; // a list of lists of item objects
for(var i = 0; i < num_test_blocks; i++){
  block = [test_stimuli.pop(), test_stimuli.pop(), fillers_gram.pop(), fillers_ungram.pop()];
  block = shuffle(block);
  test_blocks.push(block);
}


// tag information about the experiment conditions to each item

for(var i = 0; i < num_exposure_blocks; i++){
  for (var j = 0; j < block_size; j++){

    exposure_blocks[i][j]["new_block_sequence"] = i+1;
    exposure_blocks[i][j]["exposure_condition"] = exposure_cond;
    exposure_blocks[i][j]["test_condition"] = test_cond;
    exposure_blocks[i][j]["phase"] = "exposure";
    exposure_blocks[i][j]["group"] = experiment_group;

  };
};

for(var i = 0; i < num_test_blocks; i++){
  for (var j = 0; j < block_size; j++){

    test_blocks[i][j]["new_block_sequence"] = i+101;
    test_blocks[i][j]["exposure_condition"] = exposure_cond;
    test_blocks[i][j]["test_condition"] = test_cond;
    test_blocks[i][j]["phase"] = "test";
    test_blocks[i][j]["group"] = experiment_group;

  };
};
*/
// create final sequence to present to the slide
subcat = shuffle(all_stimuli.filter((stim) => stim.condition == "subcat"));
//console.log(subcat.length);
agr = shuffle(all_stimuli.filter((stim) => stim.condition == "agreement"));
//console.log(agr.length);
head = shuffle(all_stimuli.filter((stim) => stim.condition == "head_dir"));
//console.log(head.length);
bind = shuffle(all_stimuli.filter((stim) => stim.condition == "binding"));
//console.log(bind.length);
npi = shuffle(all_stimuli.filter((stim) => stim.condition == "NPI"));
//console.log(npi.length);
csc = shuffle(all_stimuli.filter((stim) => stim.condition == "CSC"));
//console.log(csc.length);
lbc = shuffle(all_stimuli.filter((stim) => stim.condition == "LBC"));
//console.log(lbc.length);
subj = shuffle(all_stimuli.filter((stim) => stim.condition == "subj_island"));
//console.log(subj.length);
adj = shuffle(all_stimuli.filter((stim) => stim.condition == "adj_island"));
//console.log(adj.length);
gram = shuffle(all_stimuli.filter((stim) => stim.condition == "gram"));
//console.log(gram.length);
ungram = shuffle(all_stimuli.filter((stim) => stim.condition == "ungram"));
//console.log(ungram.length);

var num_blocks = 5;

randomized_stims = [];
for (var i = 0; i < num_blocks; i++) {
	block = [];
	block.push(subcat.pop());
	block.push(agr.pop());
	block.push(head.pop());
	block.push(bind.pop());
	block.push(npi.pop());
	block.push(csc.pop());
	block.push(lbc.pop());
	block.push(subj.pop());
	block.push(adj.pop());
	block.push(gram.pop());
	block.push(ungram.pop());
	rand_block = shuffle(block);
	for (var j = 0; j < 11; j++) {
		var item = rand_block.pop();
		item.block_number = i+1;
		randomized_stims.push(item);
	}
}

final_item_sequence = randomized_stims; //shuffle(all_stimuli)//[exposure_blocks, test_blocks].flat().flat();
console.log(randomized_stims);


//shuffle name-condition coorelation

function resetSelectElement(selectElement) {
  var options = selectElement.options;

  // Look for a default selected option
  for (var i=0, iLen=options.length; i<iLen; i++) {

      if (options[i].defaultSelected) {
          selectElement.selectedIndex = i;
          return;
      }
  }
  // If no option is the default, select first or none as appropriate
  selectElement.selectedIndex = 0; // or -1 for no option selected
}


function make_slides(f) {
  var slides = {};
  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.single_trial = slide({
    name: "single_trial",
    start: function() {
      $(".err").hide();
      $(".display_condition").html("You are in " + exp.condition + ".");
    },
    button : function() {
      response = $("#text_response").val();
      if (response.length == 0) {
        $(".err").show();
      } else {
        exp.data_trials.push({
          "trial_type" : "single_trial",
          "response" : response
        });
        exp.go(); //make sure this is at the *end*, after you log your data
      }
    },
  });

  slides.practice_slider = slide({
    name : "practice_slider",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
    present : [{"a": 1}],
    //this gets run only at the beginning of the block
    present_handle : function(stim) {
      $(".err").hide();
      $(".errgood").hide();
			$(".err_write").hide();
			$(".text_response").hide();
			$(".interpret").hide();
		//	$(".errinterp").hide();
		//	$(".interp_err").hide();
			$("#paraphrase").val("");
			$(".sentence_reminder").hide();
      this.stim = stim;
      $(".prompt").html("<b class = \"stim_sentence\"> What did the boy see on the table? <\/b>");
      this.init_sliders();
      exp.sliderPost = null; //erase current slider value
			exp.sliderPost_interp = null;
      exp.first_response_wrong = 0;
      exp.first_response_value = null;
      exp.attempts = 0;
			exp.slide_startT = Date.now() - exp.startT;
    },

		showPrompt : function() {
			$(".prompt").show();
			$("#forgot-sentence").hide();
		  $(".sentence_reminder").show();
		},
    button : function() {
			var button1 = !$("#button1-1").is(":hidden");
			var button2 = !$("#button2-1").is(":hidden");
			var button3 = !button1 & !button2;
      if (exp.sliderPost == null) {
        $(".err").show();
      }
      else if (button1 & exp.sliderPost < 0.5) {
        exp.first_response_wrong = 1;
        exp.first_response_value = exp.sliderPost;
        exp.attempts = exp.attempts + 1;
        $(".errgood").show();
      }
      else {
				$(".err").hide();
				$(".errgood").hide();
        //this.log_responses();
				if (button1) {
					exp.acceptability = exp.sliderPost;
					exp.acceptT = (Date.now() - exp.slide_startT - exp.startT);
					console.log(exp.acceptT);
					$(".instruct").hide();
					//console.log("Button1");
				//	$(".interpret").show();
					$(".rating").hide();
					$(".text_response").show();
					$("#forgot-sentence").show();
					$(".prompt").hide();
				} else if (button2){
					//var response = $("input[type='radio'][name='interpret']:checked").val();
					//console.log(response);
					var paraphrase = $("#paraphrase").val().trim();
					console.log(paraphrase);
					console.log($(".stim_sentence")[0].innerHTML);
					if (paraphrase == "" || repeatStim(paraphrase, $(".stim_sentence")[0].innerHTML)) {
						$(".err_write").show();
					} else {
						exp.paraphraseT = Date.now() - exp.slide_startT - exp.acceptT - exp.startT;
						$(".interpret").show();
						$(".text_response").hide();
						$("#forgot-sentence").hide();
						 $(".sentence_reminder").hide();
						$(".prompt").show();
						}
					} else if (button3) {
						if (exp.sliderPost_interp == null) {
							$(".err").show();
						} else {
							exp.meaning_confidence = exp.sliderPost_interp;
							exp.confidenceT = Date.now() - exp.slide_startT - exp.paraphraseT - exp.acceptT - exp.startT;
						//	$(".errinterp").hide();
						//	$(".interpret").hide();
						//	$(".prompt").hide();

						//	$(".interp_error").hide();
        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
							this.log_responses();
							_stream.apply(this);
						}
    			}
				}
		},

		init_sliders : function() {
      utils.make_slider("#practice_slider_1", function(event, ui) {
        exp.sliderPost = ui.value;
      });
			utils.make_slider("#practice_slider_1_interp", function(event, ui) {
        exp.sliderPost_interp = ui.value;
      });
    },
    log_responses : function() {
      exp.data_trials.push({
        "acceptability" : exp.acceptability,
        "first_response_value": exp.first_response_value,
        "wrong_attempts": exp.attempts,
				"meaning_confidence": exp.meaning_confidence,
        "condition" : "practice_good",
        "block_number": "practice",
        "itemID": "practice_good",
        //"phase": "practice_good",
        "trial_sequence_total": 0, //,
				"slide_start": exp.slide_startT / 1000,
				"accept_time": exp.acceptT / 1000,
				"confidence_time": exp.confidenceT / 1000,
				"paraphrase_time": exp.paraphraseT / 1000
      });

    }
  });


  slides.post_practice_1 = slide({
    name : "post_practice_1",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });


	slides.practice_slider_mid = slide({
    name : "practice_slider_mid",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
    present : [1],

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
			$(".rating2").show();
			$(".slider_table").show();
			$(".err").hide();
			$(".errbad").hide();
			$(".err_write").hide();
			$(".text_response2").hide();
			$(".interpret2").hide();
		//	$(".errinterp").hide();
			$("#paraphrase2").val("");
			//$(".prompt").show();
			$(".sentence_reminder2").hide();
		//	$(".interp_err").hide();
			//this.stim = stim;
			$(".prompt").html("<b class=\"stim_sentence\" > I tasted the cake that John acknowledged the possibility that I would enjoy. <\/b>");
		  this.init_sliders();
			exp.sliderPost = null; //erase current slider value
			exp.sliderPost_interp = null;
			exp.first_response_wrong = 0;
			exp.first_response_value = null;
			exp.attempts = 0;
			exp.slide_startT = Date.now() - exp.startT;
    },



		button : function() {
			var button1 = !$("#button1-2").is(":hidden");
			var button2 = !$("#button2-2").is(":hidden");
			var button3 = !button1 & !button2;
			if (exp.sliderPost == null) {
				$(".err").show();
			}
			else {
				$(".err").hide();
				$(".errgood").hide();
				//this.log_responses();
				if (button1) {
					exp.acceptability = exp.sliderPost;
					exp.acceptT = (Date.now() - exp.slide_startT - exp.startT);
					console.log(exp.acceptT);
					$(".instruct").hide();
					//console.log("Button1");
				//	$(".interpret").show();
					$(".rating2").hide();
					$(".text_response2").show();
					$("#forgot-sentence").show();
					$(".prompt").hide();
				} else if (button2){
					//var response = $("input[type='radio'][name='interpret']:checked").val();
					//console.log(response);
					var paraphrase = $("#paraphrase2").val().trim();
					console.log(paraphrase);
					console.log($(".stim_sentence")[0].innerHTML);
					if (paraphrase == "" || repeatStim(paraphrase, $(".stim_sentence")[0].innerHTML)) {
						$(".err_write").show();
					} else {
						exp.paraphraseT = Date.now() - exp.slide_startT - exp.acceptT - exp.startT;
						$(".interpret2").show();
						$(".text_response2").hide();
						$("#forgot-sentence").hide();
						$(".sentence_reminder2").hide();
						$(".prompt").show();
						}
					} else if (button3) {
						if (exp.sliderPost_interp == null) {
							$(".err").show();
						} else {
							exp.meaning_confidence = exp.sliderPost_interp;
							exp.confidenceT = Date.now() - exp.slide_startT - exp.paraphraseT - exp.acceptT - exp.startT;
						//	$(".errinterp").hide();
						//	$(".interpret").hide();
						//	$(".prompt").hide();

						//	$(".interp_error").hide();
				/* use _stream.apply(this); if and only if there is
				"present" data. (and only *after* responses are logged) */
							this.log_responses();
							_stream.apply(this);
						}
					}
				}
		},
		showPrompt : function() {
			$(".prompt").show();
			$(".sentence_reminder2").show();
			$("#forgot-sentence2").hide();
			//$(".target-reminder").show();
		},
    init_sliders : function() {
      utils.make_slider("#practice_slider_2", function(event, ui) {
        exp.sliderPost = ui.value;
      });
			utils.make_slider("#practice_slider_2_interp", function(event, ui) {
        exp.sliderPost_interp = ui.value;
      });
    },
    log_responses : function() {
      exp.data_trials.push({
        "response" : exp.sliderPost,
        "first_response_value": exp.first_response_value,
        "wrong_attempts": exp.attempts,
				"meaning_confidence": exp.meaning_confidence,
        "item_type" : "practice_mid",
        "block_number": "practice",
        "itemID": "practice_mid",
        //"phase": "practice_mid",
        "trial_sequence_total": 0,
      //  "group": experiment_group
			"slide_start": exp.slide_startT / 1000,
			"accept_time": exp.acceptT / 1000,
			"confidence_time": exp.confidenceT / 1000,
			"paraphrase_time": exp.paraphraseT / 1000
      });

    }
  });

  slides.post_practice_2 = slide({
    name : "post_practice_2",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });




  slides.practice_slider_bad = slide({
    name : "practice_slider_bad",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
    present : [1],


    //this gets run only at the beginning of the block
    present_handle : function(stim) {
			$(".rating3").show();
			$(".slider_table").show();
			$(".err").hide();
			$(".errbad").hide();
			$(".err_write").hide();
			$(".text_response3").hide();
			$(".interpret3").hide();
			$(".errinterp").hide();
			$("#paraphrase3").val("");
			$(".prompt").show();
			$(".sentence_reminder3").hide();
			//this.stim = stim;
			$(".interp_err").hide();
			$(".prompt").html("<b class=\"stim_sentence\" > Does minister prime imply the senate will the that report the review? <\/b>");
		  this.init_sliders();
			exp.sliderPost = null; //erase current slider value
			exp.sliderPost_interp = null;
			exp.first_response_wrong = 0;
			exp.first_response_value = null;
			exp.attempts = 0;
			exp.slide_startT = Date.now() - exp.startT;
    },



		button : function() {
			var button1 = !$("#button1-3").is(":hidden");
			var button2 = !$("#button2-3").is(":hidden");
			var button3 = !button1 & !button2;
			if (exp.sliderPost == null) {
				$(".err").show();
			}
			else if (button1 & exp.sliderPost >= 0.5) {
		        exp.first_response_wrong = 1;
		        exp.first_response_value = exp.sliderPost;
		        exp.attempts = exp.attempts + 1;
		        $(".errbad").show();
		  }
			else {
				$(".err").hide();
				$(".errbad").hide();
				//this.log_responses();
				if (button1) {
					exp.acceptability = exp.sliderPost;
					exp.acceptT = (Date.now() - exp.slide_startT - exp.startT);
					console.log(exp.acceptT);
					$(".instruct").hide();
					//console.log("Button1");
				//	$(".interpret").show();
					$(".rating3").hide();
					$(".text_response3").show();
					$("#forgot-sentence").show();
					$(".prompt").hide();
				} else if (button2){
					//var response = $("input[type='radio'][name='interpret']:checked").val();
					//console.log(response);
					var paraphrase = $("#paraphrase3").val().trim();
					console.log(paraphrase);
					console.log($(".stim_sentence")[0].innerHTML);
					if (paraphrase == "" || repeatStim(paraphrase, $(".stim_sentence")[0].innerHTML)) {
						$(".err_write").show();
					} else {
						exp.paraphraseT = Date.now() - exp.slide_startT - exp.acceptT - exp.startT;
						$(".interpret3").show();
						$(".text_response3").hide();
						$("#forgot-sentence").hide();
						 $(".sentence_reminder3").hide();
						$(".prompt").show();
						}
					} else if (button3) {
						if (exp.sliderPost_interp == null) {
							$(".err").show();
						} else {
							exp.meaning_confidence = exp.sliderPost_interp;
							exp.confidenceT = Date.now() - exp.slide_startT - exp.paraphraseT - exp.acceptT - exp.startT;
						//	$(".errinterp").hide();
						//	$(".interpret").hide();
						//	$(".prompt").hide();

						//	$(".interp_error").hide();
				/* use _stream.apply(this); if and only if there is
				"present" data. (and only *after* responses are logged) */
							this.log_responses();
							_stream.apply(this);
						}
					}
				}
		},
		showPrompt : function() {
			$(".prompt").show();
			$(".sentence_reminder3").show();
			$("#forgot-sentence3").hide();
			//$(".target-reminder").show();
		},
    init_sliders : function() {
      utils.make_slider("#practice_slider_3", function(event, ui) {
        exp.sliderPost = ui.value;
      });
			utils.make_slider("#practice_slider_3_interp", function(event, ui) {
				exp.sliderPost_interp = ui.value;
			});
    },
    log_responses : function() {
      exp.data_trials.push({
        "response" : exp.sliderPost,
        "first_response_value": exp.first_response_value,
        "wrong_attempts": exp.attempts,
				"meaning_confidence": exp.meaning_confidence,
        "item_type" : "practice_bad",
        "block_number": "practice",
        "itemID": "practice_bad",
        //"phase": "practice_bad",
        "trial_sequence_total": 0,
      //  "group": experiment_group
			"slide_start": exp.slide_startT / 1000,
			"accept_time": exp.acceptT / 1000,
			"confidence_time": exp.confidenceT / 1000,
			"paraphrase_time": exp.paraphraseT / 1000
      });

    }
  });



  slides.last_reminder = slide({
    name : "last_reminder",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }

  });



  slides.one_slider = slide({
    name : "one_slider",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
    present : final_item_sequence,

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
      //$(".err").hide();
      this.stim = stim; //I like to store this information in the slide so I can record it later.
    //  $(".context").html(stim.presented_context);
			$(".rating_main").show();
			$("#main_slider").show();
			$(".slider_table").show();
			$(".err").hide();
			$(".errbad").hide();
			$(".err_write").hide();
			$(".text_response_main").hide();
			$(".interpret_main").hide();
			$(".errinterp").hide();
			$("#paraphrase_main").val("");
			$(".target").show();		//$(".prompt").show();
      $(".target").html(stim.Target);
			$(".interp_err").hide();
		//	$("input[type='radio'][name='interpret_main']").prop('checked', false);
      this.init_sliders()
      exp.sliderPost = null;
			exp.sliderPost_interp = null;
			exp.sentence = stim.Target; //erase current slider value
			exp.slide_startT = Date.now() - exp.startT;
    },




		button : function() {
			var button1 = !$("#button1-m").is(":hidden");
			var button2 = !$("#button2-m").is(":hidden");
			var button3 = !button1 & !button2;
			if (exp.sliderPost == null) {
				$(".err").show();
			}
			else {
				$(".err").hide();
				//this.log_responses();
				if (button1) {
					exp.acceptability = exp.sliderPost;
					exp.acceptT = (Date.now() - exp.slide_startT - exp.startT);
					console.log(exp.acceptT);
					$(".instruct").hide();
					//console.log("Button1");
				//	$(".interpret").show();
					$(".rating_main").hide();
					$(".text_response_main").show();
			//		$("#forgot-sentence").show();
					$(".target").hide();
				} else if (button2){
					//var response = $("input[type='radio'][name='interpret']:checked").val();
					//console.log(response);
					var paraphrase = $("#paraphrase_main").val().trim();
					console.log(paraphrase);
					console.log($(".stim_sentence")[0].innerHTML);
					if (paraphrase == "" || repeatStim(paraphrase, $(".stim_sentence")[0].innerHTML)) {
						$(".err_write").show();
					} else {
						exp.paraphrase = paraphrase;
						exp.paraphraseT = Date.now() - exp.slide_startT - exp.acceptT - exp.startT;
						$(".interpret_main").show();
						$(".text_response_main").hide();

					//$("#forgot-sentence").hide();
					//	 $(".sentence_reminder").hide();
						$(".target").show();
						}
					} else if (button3) {
						if (exp.sliderPost_interp == null) {
							$(".err").show();
						} else {
							exp.meaning_confidence = exp.sliderPost_interp;
							exp.confidenceT = Date.now() - exp.slide_startT - exp.paraphraseT - exp.acceptT - exp.startT;
						//	$(".errinterp").hide();
						//	$(".interpret").hide();
						//	$(".prompt").hide();

						//	$(".interp_error").hide();
				/* use _stream.apply(this); if and only if there is
				"present" data. (and only *after* responses are logged) */
							this.log_responses();
							_stream.apply(this);
						}
					}
				}
		},

    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
			utils.make_slider("#single_slider_interp", function(event, ui) {
        exp.sliderPost_interp = ui.value;
      });
    },

    log_responses : function() {
      exp.data_trials.push({
        // item-specific fields
        "rating" : exp.acceptability,
        "condition" : this.stim.condition,
        "trial_sequence_total": order,
        "block_number": this.stim.block_number,
        //"item_number": this.stim.lex_items,
        "sentence_id": this.stim.itemID,
				"stimulus": exp.sentence,
				"paraphrase": exp.paraphrase,
				"meaning_confidence": exp.meaning_confidence,
				"slide_start": exp.slide_startT / 1000,
				"accept_time": exp.acceptT / 1000,
				"confidence_time": exp.confidenceT / 1000,
				"paraphrase_time": exp.paraphraseT / 1000
        //"phase": this.stim.phase,
        // experiment-general fields
        //"exposure_condition": this.stim.exposure_condition,
        //"condition": this.stim.condition,
        //"group": this.stim.group
      });
      order = order + 1;
    }
  });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
        comments : $("#comments").val(),
        problems: $("#problems").val(),
        fairprice: $("#fairprice").val()
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          "condition" : exp.condition,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      proliferate.submit(exp.data);
    }
  });

  return slides;
}

/// init ///
function init() {
	exp.sentence = "";
	exp.slide_startT = 0;
	exp.between_blocksT = 0;
	exp.acceptT = 0;
	exp.confidenceT = 0;
	exp.paraphraseT = 0;
	exp.paraphrase = "";
	exp.acceptability = 0;
	exp.meaning_confidence  = 0;
  exp.trials = [];
  exp.catch_trials = [];
  //exp.condition = _.sample(["condition 1", "condition 2"]); //can randomize between subject conditions here
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["i0", "instructions", "practice_slider", "practice_slider_mid",  "practice_slider_bad", "last_reminder", 'one_slider', 'subj_info', 'thanks'];
// "post_practice_1",, "post_practice_2"
  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    exp.go();
  });

  exp.go(); //show first slide
}
