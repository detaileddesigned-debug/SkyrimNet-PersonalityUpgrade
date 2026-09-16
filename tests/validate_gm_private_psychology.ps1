$ErrorActionPreference = 'Stop'

function Read-Text([string]$Path) {
    return [IO.File]::ReadAllText((Resolve-Path $Path), [Text.Encoding]::UTF8)
}

function Assert-Contains([string]$Name, [string]$Text, [string]$Needle) {
    if (-not $Text.Contains($Needle)) { throw "FAIL [$Name]: missing: $Needle" }
    Write-Output "PASS [$Name]"
}

$private = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/submodules/character_bio/0690_gamemaster_private_context.prompt'
$scene = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/gamemaster_scene_planner.prompt'
$action = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/gamemaster_action_selector.prompt'

Assert-Contains 'private-mode-exists' $private 'render_mode == "gm_private"'
Assert-Contains 'private-has-personality' $private 'render_character_profile("bio_personality", actorUUID)'
Assert-Contains 'private-has-aspirations' $private 'render_character_profile("bio_aspirations", actorUUID)'
Assert-Contains 'private-has-relationships' $private 'render_character_profile("bio_relationships", actorUUID)'
Assert-Contains 'private-has-memory-history' $private 'render_character_profile("bio_long_term_memories", actorUUID)'
Assert-Contains 'private-has-epistemic-boundary' $private 'Do NOT assume other characters know this information'
Assert-Contains 'private-player-nonagentic-boundary' $private 'NEVER use it to decide, predict as certain, or author what the player will say, do, accept, refuse, or choose.'

Assert-Contains 'scene-planner-gets-private-psychology' $scene 'render_character_profile("gm_private", npc.UUID)'
Assert-Contains 'scene-player-gets-private-profile' $scene 'render_character_profile("gm_private", player.UUID)'
Assert-Contains 'scene-player-remains-uncontrollable' $scene 'The Player is UNCONTROLLABLE'

Assert-Contains 'action-selector-gets-private-psychology' $action 'render_character_profile("gm_private", npc.UUID)'
Assert-Contains 'action-player-gets-private-profile' $action 'render_character_profile("gm_private", player.UUID)'
Assert-Contains 'action-selector-uses-private-psychology-deliberately' $action 'Private Psychology in Action Selection'

Write-Output 'GameMaster private psychology validation passed.'