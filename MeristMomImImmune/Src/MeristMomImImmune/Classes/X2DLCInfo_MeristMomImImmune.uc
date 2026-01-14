class X2DLCInfo_MeristMomImImmune extends X2DownloadableContentInfo;

var config bool bLog;

var config array<name> IncludeDamageTypes;
var config array<name> AbilitiesToHide;

static event OnPostTemplatesCreated()
{
    `LOG("OnPostTemplatesCreated", default.bLog, 'MeristMomImImmune');

    PatchCharacterTemplates();
    PatchAbilityTemplates();
}

static function PatchCharacterTemplates()
{
    local X2CharacterTemplateManager    CharacterTemplateManager;
    local X2CharacterTemplate           CharacterTemplate;
    local array<X2DataTemplate>         DataTemplates;
    local X2DataTemplate                Template, DiffTemplate;
    local bool                          bLoggedTemplate;

    CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    foreach CharacterTemplateManager.IterateTemplates(Template, none)
    {
        bLoggedTemplate = !default.bLog;
        CharacterTemplateManager.FindDataTemplateAllDifficulties(Template.DataName, DataTemplates);
        foreach DataTemplates(DiffTemplate)
        {
            CharacterTemplate = X2CharacterTemplate(DiffTemplate);
            if (Template != none)
            {
                `Log("Adding " $ class'X2Ability_MomImImmune'.default.MomImImmuneAbilityName $ " to " $ CharacterTemplate.DataName, !bLoggedTemplate, 'MomImImmune');
                CharacterTemplate.Abilities.InsertItem(0, class'X2Ability_MomImImmune'.default.MomImImmuneAbilityName);
                bLoggedTemplate = true;
            }
        }
    }
}

static function PatchAbilityTemplates()
{
    local X2AbilityTemplateManager  AbilityTemplateManager;
    local X2AbilityTemplate         Template;
    local X2Effect                  Effect;
    local X2Effect_Persistent       PersistentEffect;
    local name                      AbilityName;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach default.AbilitiesToHide(AbilityName)
    {
        Template = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
        if (Template != none)
        {
            `LOG("Patching " $ AbilityName, default.bLog, 'MomImImmune');
            foreach Template.AbilityTargetEffects(Effect)
            {
                PersistentEffect = X2Effect_Persistent(Effect);
                if (PersistentEffect != none)
                {
                    `LOG("    Hiding " $ PersistentEffect.EffectName, default.bLog, 'MomImImmune');
                    PersistentEffect.bDisplayInUI = false;
                }
            }
        }
    }
}

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    switch (InString)
    {
        case "M31_Immunities":
            OutString = GetUnitImmunitiesString(ParseObj, StrategyParseOb, GameState);
            return true;
    }

    return false;
}

static private function string GetUnitImmunitiesString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameStateHistory  History;
    local XComGameState_Effect  EffectState;
    local XComGameState_Unit    UnitState;
    local StateObjectReference  EffectRef;
    local X2Effect_Persistent   Effect;
    local array<string>         Immunities;
    local string                LocalizedDamageType;
    local name                  DamageType;
    local bool                  bImmune;

    History = `XCOMHISTORY;

    EffectState = XComGameState_Effect(ParseObj);

    if (EffectState != none)
    {
        UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        if (UnitState != none)
        {
            `LOG("Checking " $ UnitState.GetMyTemplateName(), default.bLog, 'MomImImmune');
            foreach default.IncludeDamageTypes(DamageType)
            {
                bImmune = false;
                if (UnitState.IsImmuneToDamageCharacterTemplate(DamageType))
                {
                    bImmune = true;
                    LocalizedDamageType = Localize("LocalizedDamageTypes", string(DamageType), "MeristMomImImmune");
                    if (Immunities.Find(LocalizedDamageType) == INDEX_NONE)
                    {
                        Immunities.AddItem(LocalizedDamageType);
                    }
                }
                else
                {
                    foreach UnitState.AffectedByEffects(EffectRef)
                    {
                        EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
                        Effect = EffectState.GetX2Effect();
                        if (Effect.ProvidesDamageImmunity(EffectState, DamageType))
                        {
                            bImmune = true;
                            LocalizedDamageType = Localize("LocalizedDamageTypes", string(DamageType), "MeristMomImImmune");
                            if (Immunities.Find(LocalizedDamageType) == INDEX_NONE)
                            {
                                Immunities.AddItem(LocalizedDamageType);
                            }
                        }
                    }
                }
                `LOG(DamageType $ " (" $ LocalizedDamageType $ "): " $ bImmune, default.bLog, 'MomImImmune');
            }
            return JoinStrings(Immunities, ", ");
        }
    }

    return "";
}

static function string JoinStrings(array<string> Arr, optional string Delim = "")
{
    local string ReturnString;
    local int i;

    // Handle it this way so there's no delim after the final member.
    for (i = 0; i < Arr.Length - 1; i++)
    {
        ReturnString $= Arr[i] $ Delim;
    }
    if (Arr.Length > 0)
    {
        ReturnString $= Arr[Arr.Length - 1];
    }

    return ReturnString;
}