public without sharing class PSBadgeUtils {
    public static void assignBadge(ID networkId, String badgeName, ID giverId, ID recipientId, String msg, 
                                   Boolean chatterPost, Boolean duplicateBadge)
    {
        // get the badge definition id
        ID badgeDefinitionId = null;
        List<WorkBadgeDefinition> wbdList = [SELECT Id, Name FROM WorkBadgeDefinition WHERE networkId = :networkId AND Name = :badgeName];
        
        
        if (wbdList == null)
        {
            //throw new PSException('Badge name does not exist for the network');
            return;
        }
        else if (wbdList.size() > 1)
        {
            //throw new PSException('Multiple badge names exist for the network');
            return;
        }
        
        badgeDefinitionId = wbdList[0].Id;
        
        
        // check if duplicate badge already exists
        if (!duplicateBadge)
        {
            List<WorkBadge> badgeList = [SELECT Id FROM WorkBadge WHERE DefinitionId = :badgeDefinitionId AND NetworkID = :networkId AND
                                        RecipientId = :recipientId];
            if (badgeList != null && badgeList.size() > 0)
            {
                return;
            }
        }
        
        WorkThanks thanks = new WorkThanks ();
        thanks.NetworkId = networkId;
        thanks.GiverID = giverId;
        thanks.Message = msg;
        insert thanks;
        
        WorkBadge badge = new WorkBadge();
        badge.DefinitionId = badgeDefinitionId;
        badge.NetworkID = networkId;
        badge.RecipientId = recipientID;
        badge.SourceId = thanks.id;
        insert badge;
        
        if (chatterPost)
        {
            FeedItem feedItem = new FeedItem();
            
            feedItem.NetworkScope = networkId;
            feedItem.ParentId = recipientID;
            feedItem.RelatedRecordId = thanks.id;
            feedItem.Body = msg;
            feedItem.Type = 'RypplePost';
            feedItem.Visibility = 'AllUsers';
            insert feedItem;
        }

    }
}