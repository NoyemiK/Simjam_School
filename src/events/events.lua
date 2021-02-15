local EVENTS = {
  database = {
    -- Endings
    END_FAIL = {
      title = "Kicked outta School!",
      text  = "Well crap. You completely blew it. You failed. Forever...\n  ... just kidding. You can start again if you like, or hit the little [x] in the corner of the game window to end the game.",
      choices = {"OK"}
    },
    END_OK = {
      title = "Adequate Performer",
      text  = "You did... alright in school. Luckily, they say real life doesn't truly begin until after university anyway. You can try again, maybe you'll get a different student this time...?",
      choices = {"Nice!"}
    },
    END_GOOD = {
      title = "True Believer",
      text  = "You did a lot of stuff, both in and out of school. Especially out of school. If you wanted, you might as well skip getting a degree altogether and just work on whatever you want to. Unless your pursuit is medicine, then you definitely need to get your butt to school.",
      choices = {"Is this winning?","I won't question anything anymore."}
    },
    -- Cooking
    COOKING1 = {
      title = "The Next Jordan Rimsy?",
      text  = "  You've been cooking and cooking and cooking your heart out these first few weeks. You've been watching every possible video on the ol' internet tube. You've even made your first homemade PB and J. The question remains: Will this be a career for you someday? Only if it can be elevated to the place of an art form in your mind.",
      choices = {"Maybe&","Keep dreamin', pal!"}
    },
    COOKING2 = {
      title = "All Recipes",
      text  = "  In the past few weeks you've expanded your basic culinary knowledgebase with some fine additions that include, but are not limited to: tasty homemade flatbreads, bespoke pasta sauces, how to use a sharp knife without getting cut, and dinner party etiquette.",
      choices = {"... dinner party etiquette?"}
    },
    COOKING3 = {
      title = "Unexpected Gift",
      text  = "  Your parents have taken note of your culinary endeavours and decided to purchase a personal chef knife and kitchen utility knife for you in particular. It's actually quite a nice knife, befitting a skilled kitcheneer such as yourself! Now it's time to slice up a storm and get some yakisoba on the table.",
      choices = {"All right!"}
    },
    
    -- Digital Necromancy
    DIGINOM1 = {
      title = "It Begins...",
      text  = "  You have finished the first chapter of your journey into the dark arts... the Digital Necromancy Project. To further your efforts, it might be prudent to study programming in the future.",
      choices = {"Excellent..."}
    },
    DIGINOM2 = {
      title = "DIGINOM BBS",
      text  = "  It's hard work, trying to communicate with the spirit world through a mere consumer machine. However, a sampling of various Goth factions have taken interest in your pursuit and started [DIGINOM], a modern BBS for reality hackers and a neutral ground for the Goth clans.",
      choices = {"Ugh, who invited the mallgoths?","Finally, people who understand me!"}
    },
    DIGINOM3 = {
      title = "The Goddess in the Machine",
      text  = "  Your work into communication and archival of occult forces through the fragile medium of computers has merged the paths of the digital and the analog. You have found the Great Goddess on the other side of the rift, but you will never be able to truly touch it through these means alone. You can sample it, however.",
      choices = {"This is a big step for the Nail clan."}
    }
  }
}

return EVENTS