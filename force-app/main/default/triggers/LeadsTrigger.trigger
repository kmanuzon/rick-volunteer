trigger LeadsTrigger on Lead (after insert)
{
    switch on Trigger.operationType
    {
        when AFTER_INSERT
        {
            LeadsTriggerHandler.newInstance().onAfterInsert();
        }
    }
}
