# [WOTC] Mom, I'm Immune
Steam Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=3646566000

## What is this?
This mod adds adds a passive ability to all units that lists all damage types the unit is currently immune to.

## Configuration
All configuration can be found in `XComGame.ini`.

`IncludeDamageTypes` is an array of damage types that can be listed in the immunities. If you add new entires to this list, make sure to add localized names for these types in `MeristMomImImmune.int`.

Example:

```
>>> XComGame.ini <<<

+IncludeDamageTypes = "AHWRequiemCorrosion"

>>> MeristMomImImmune.int <<<

AHWRequiemCorrosion = "Requiem Corrosion"
```

`AbilitiesToHide` is an array of abilities which effects will be hidden in tactical. Useful for hiding other abilities that show immunities to reduce the amount of clutter.

## Compatibility
This mod should be compatible with anything.
