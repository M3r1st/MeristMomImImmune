class X2Effect_Immunities extends X2Effect_Persistent;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local name DamageType;

    foreach class'X2DLCInfo_MeristMomImImmune'.default.IncludeDamageTypes(DamageType)
    {
        if (TargetUnit.IsImmuneToDamage(DamageType))
        {
            return true;
        }
    }

    return false;
}