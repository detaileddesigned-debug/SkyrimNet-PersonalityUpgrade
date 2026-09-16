$ErrorActionPreference = 'Stop'

function Read-Text([string]$Path) {
    return [IO.File]::ReadAllText((Resolve-Path $Path), [Text.Encoding]::UTF8)
}
function Assert-Contains([string]$Name,[string]$Text,[string]$Needle){if(-not $Text.Contains($Needle)){throw "FAIL [$Name]: missing: $Needle"}; Write-Output "PASS [$Name]"}
function Assert-NotContains([string]$Name,[string]$Text,[string]$Needle){if($Text.Contains($Needle)){throw "FAIL [$Name]: forbidden: $Needle"}; Write-Output "PASS [$Name]"}

$pd = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/player_dialogue.prompt'
$pt = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/player_thoughts.prompt'
$nt = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/npc_thoughts.prompt'

Assert-Contains 'transform-preserves-player-intent' $pd 'The opinion, confidence level, and emotional stance in the input are fixed.'
Assert-Contains 'event-trigger-does-not-author-player' $pd 'Do not author speech or actions for the human player from an event trigger.'
Assert-Contains 'no-input-does-not-author-player' $pd 'No player-authored dialogue was supplied. Do not invent dialogue or actions for the human player.'
Assert-NotContains 'old-autonomous-player-line-removed' $pd 'Say something aloud'

Assert-Contains 'player-choice-profile-not-authority' $pt 'must not be treated as proof of what the player "would really do."'
Assert-Contains 'player-choice-explicit-intent-strongest' $pt 'preserve that intent as the strongest constraint'
Assert-Contains 'player-event-appraisal-first' $pt 'What does this event mean to you given what you chose, expected, valued, and remember?'
Assert-NotContains 'player-old-gut-reaction-removed' $pt "What's your gut reaction?"

Assert-Contains 'npc-event-appraisal-first' $nt 'What does this mean to you in light of your expectations, memories, relationships, and current concerns?'
Assert-Contains 'npc-combat-appraisal-first' $nt 'Interpret the fight through what is at stake for you'
Assert-NotContains 'npc-old-gut-reaction-removed' $nt "What's your gut reaction?"

Write-Output 'Core prompt conflict validation passed.'