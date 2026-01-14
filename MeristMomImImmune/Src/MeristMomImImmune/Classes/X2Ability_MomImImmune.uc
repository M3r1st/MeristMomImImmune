class X2Ability_MomImImmune extends X2Ability;

var privatewrite name MomImImmuneAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(MomImImmune());

    return Templates;
}

static function X2AbilityTemplate MomImImmune()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, default.MomImImmuneAbilityName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_immunities";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = default.MomImImmuneAbilityName;
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    Template.bCrossClassEligible = false;

    Template.bHideOnClassUnlock = true;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;

    return Template;
}

defaultproperties
{
    MomImImmuneAbilityName = "M31_MomImImmune"
}