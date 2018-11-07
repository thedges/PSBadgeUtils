trigger PSChatterActivityTrigger on ChatterActivity (after update) {
    
    for (ChatterActivity ca : Trigger.New) {
        if (ca.PostCount >= 10) {
            
            PSBadgeUtils.assignBadge(null, 
                                     'Gold Star', 
                                     '005f4000000FfAJAA0',    // user: "Automated Process"
                                     ca.ParentId, 
                                     'You are rocking the chatter posts!', 
                                     true, false);

        }
    }

}