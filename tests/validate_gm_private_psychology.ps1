$ErrorActionPreference = 'Stop'

function Read-Text([string]$Path) {
    return [IO.File]::ReadAllText((Resolve-Path $Path), [Text.Encoding]::UTF8)
}

function Assert-Contains([string]$Name, [string]$Text, [string]$Needle) {
    if (-not $Text.Contains($Needle)) { throw "FAIL [$Name]: missing: $Needle" }
    Write-Output "PASS [$Name]"
}

function Assert-NotContains([string]$Name, [string]$Text, [string]$Needle) {
    if ($Text.Contains($Needle)) { throw "FAIL [$Name]: forbidden: $Needle" }
    Write-Output "PASS [$Name]"
}

$private = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/submodules/character_bio/0690_gamemaster_private_context.prompt'
$scene = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/gamemaster_scene_planner.prompt'
$action = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/gamemaster_action_selector.prompt'

Assert-Contains 'private-mode-is-npc-only' $private 'render_mode == "gm_private" and not is_player(actorUUID)'
Assert-Contains 'private-has-personality' $private 'render_character_profile("bio_personality", actorUUID)'
Assert-Contains 'private-has-aspirations' $private 'render_character_profile("bio_aspirations", actorUUID)'
Assert-Contains 'private-has-relationships' $private 'render_character_profile("bio_relationships", actorUUID)'
Assert-Contains 'private-has-memory-history' $private 'render_character_profile("bio_long_term_memories", actorUUID)'
Assert-Contains 'private-has-epistemic-boundary' $private 'Do NOT assume other characters know this information'

Assert-Contains 'scene-planner-gets-private-psychology' $scene 'render_character_profile("gm_private", npc.UUID)'
Assert-Contains 'scene-planner-uses-private-psychology-deliberately' $scene 'Private Psychology as Planning Material'
Assert-NotContains 'scene-player-does-not-get-private-profile' $scene 'render_character_profile("gm_private", player.UUID)'

Assert-Contains 'action-selector-gets-private-psychology' $action 'render_character_profile("gm_private", npc.UUID)'
Assert-Contains 'action-selector-uses-private-psychology-deliberately' $action 'Private Psychology in Action Selection'
Assert-NotContains 'action-player-does-not-get-private-profile' $action 'render_character_profile("gm_private", player.UUID)'

Write-Output 'GameMaster private psychology validation passed.'