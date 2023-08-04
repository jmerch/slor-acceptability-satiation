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

// experiment parameters

num_exposure_items = 12; // how many target items in the exposure phase?
num_test_items = 10; // how many target items in the test phase?
num_unique_lex_items = num_exposure_items + num_test_items;
num_fillers = 11; /* half the number of target items. Each type of filler
                  will have this many items */
block_size = 4;
num_exposure_blocks = num_exposure_items/2; // 2 target items per block
num_test_blocks = num_test_items/2; // 2 target items per block

// choose an experimental group
// match sees the same condition throughout
// mismatch sees different conditions on exposure and test
experiment_group = shuffle(["match", "mismatch", "control"])[0];

// choose experimental condition
shuffled_conditions = ["SUBJ", "WH"]; //shuffle(["SUBJ","WH"]);
test_cond = shuffled_conditions[0];
exposure_cond = shuffled_conditions[1];

if(experiment_group == "match"){
  exposure_cond = test_cond;
}
if(experiment_group == "control"){
  exposure_cond = "POLAR";
}

console.log(experiment_group);
console.log("exp", exposure_cond);
console.log("test", test_cond);

// sort items into pools we can sample from
// only take <num_unique_lex_items> total items from stimuli list

// in the 'match' group, these will have the same items
exposure_pool = all_stimuli.filter(function (e){
  return e.condition == exposure_cond && e.lex_items < num_unique_lex_items+1;
});
test_pool = all_stimuli.filter(function (e){
  return e.condition == test_cond && e.lex_items < num_unique_lex_items+1;
});

// split data into phases
// phases are disjoint sets of lexical items
exposure_stimuli = shuffle(exposure_pool).slice(0,num_exposure_items);
test_stimuli = test_pool.filter(function (t){
  // t.lex_items not in exposure_stimuli
  return !(exposure_stimuli.find(e => e.lex_items == t.lex_items));
});

// do the same with fillers

fillers_gram = all_stimuli.filter(function (e){
  return e.condition == "FILL" && e.lex_items < num_fillers+101;
});
fillers_ungram = all_stimuli.filter(function (e){
  return e.condition == "UNGRAM" && e.lex_items < num_fillers+117;
});

fillers_gram = shuffle(fillers_gram);
fillers_ungram = shuffle(fillers_ungram);


// split phases into blocks

// each block has two target items, one grammatical filler,
// and one ungrammatical filler
exposure_blocks = []; // a list of lists of item objects
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

// create final sequence to present to the slide
final_item_sequence = [exposure_blocks, test_blocks].flat().flat();



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
      this.stim = stim;
      $(".prompt").html("Context: The boy saw an apple on the table. <p>  Target: <b> What did the boy see on the table? <\/b>");
      this.init_sliders();
      exp.sliderPost = null; //erase current slider value
      exp.first_response_wrong = 0;
      exp.first_response_value = null;
      exp.attempts = 0;
    },
    button : function() {
      if (exp.sliderPost == null) {
        $(".err").show();
      } 
      else if (exp.sliderPost < 0.5) {
        exp.first_response_wrong = 1;
        exp.first_response_value =exp.sliderPost;
        exp.attempts = exp.attempts + 1;
        $(".errgood").show();
      }
      else {
        this.log_responses();
        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
      }
    },
    init_sliders : function() {
      utils.make_slider("#practice_slider_1", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },
    log_responses : function() {
      exp.data_trials.push({
        "response" : exp.sliderPost,
        "first_response_value": exp.first_response_value,
        "wrong_attempts": exp.attempts,
        "item_type" : "practice_good",
        "block_sequence": "practice",
        "item_number": "practice_good",
        "phase": "practice_good",
        "trial_sequence_total": 0,
        "group": experiment_group
      });

    }
  });


  slides.post_practice_1 = slide({
    name : "post_practice_1",
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
      $(".err").hide();
      $(".errbad").hide();
      $(".prompt").html("Context: The girl slept under the bed. <p>  Target: <b> Who the bed was slept under? <\/b>");
      this.init_sliders();
      exp.sliderPost = null; //erase current slider value
      exp.first_response_wrong = 0;
      exp.first_response_value = null;
      exp.attempts = 0;
    },
    button : function() {
      if (exp.sliderPost == null) {
        $(".err").show();
      } 
      else if (exp.sliderPost > 0.5) {
        exp.first_response_wrong = 1;
        exp.first_response_value = exp.sliderPost;
        exp.attempts = exp.attempts + 1;
        $(".errbad").show();
      }
      else {
        this.log_responses();
        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
      }
    },
    init_sliders : function() {
      utils.make_slider("#practice_slider_2", function(event, ui) {
        exp.sliderPost = ui.value;
        
      });
    },
    log_responses : function() {
      exp.data_trials.push({
        "response" : exp.sliderPost,
        "first_response_value": exp.first_response_value,
        "wrong_attempts": exp.attempts,
        "item_type" : "practice_bad",
        "block_sequence": "practice",
        "item_number": "practice_bad",
        "phase": "practice_bad",
        "trial_sequence_total": 0,
        "group": experiment_group
      });

    }
  });

  slides.post_practice_2 = slide({
    name : "post_practice_2",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
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
      $(".err").hide();
      this.stim = stim; //I like to store this information in the slide so I can record it later.
      $(".context").html(stim.presented_context);
      $(".target").html("Target: " + stim.presented_target);
      this.init_sliders()
      exp.sliderPost = null; //erase current slider value
    },

    button : function() {
      if (exp.sliderPost == null) {
        $(".err").show();
      } else {
        this.log_responses();

        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
      }
    },

    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },

    log_responses : function() {
      exp.data_trials.push({
        // item-specific fields
        "response" : exp.sliderPost,
        "item_type" : this.stim.condition,
        "trial_sequence_total": order,
        "block_sequence": this.stim.new_block_sequence,
        "item_number": this.stim.lex_items,
        "sentence_id": this.stim.item,
        "phase": this.stim.phase,
        // experiment-general fields
        "exposure_condition": this.stim.exposure_condition,
        "test_condition": this.stim.test_condition,
        "group": this.stim.group
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
  exp.structure=["i0", "instructions", "practice_slider", "post_practice_1", "practice_slider_bad", "post_practice_2", "last_reminder", 'one_slider', 'subj_info', 'thanks'];

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
