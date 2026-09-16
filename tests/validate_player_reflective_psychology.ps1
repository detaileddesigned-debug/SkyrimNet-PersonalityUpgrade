$ErrorActionPreference = 'Stop'

function Read-Text([string]$Path) {
    return [IO.File]::ReadAllText((Resolve-Path $Path), [Text.Encoding]::UTF8)
}

function Assert-Contains([string]$Name, [string]$Text, [string]$Needle) {
    if (-not $Text.Contains($Needle)) { throw "FAIL [$Name]: missing: $Needle" }
    Write-Output "PASS [$Name]"
}

$psych = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/submodules/guidelines/0600_psychological_realism.prompt'
$epistemic = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/submodules/guidelines/0610_epistemic_boundaries.prompt'
$bio = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/dynamic_bio_update.prompt'
$private = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/submodules/character_bio/0690_gamemaster_private_context.prompt'

Assert-Contains 'player-reflective-psychology-exists' $psych '## Reflective Player Psychology'
Assert-Contains 'player-psychology-nonagentic' $psych 'descriptive and reflective, NOT agentic'
Assert-Contains 'player-self-evaluation' $psych 'Why did I do that?'
Assert-Contains 'player-repeated-behavior-evolves-profile' $psych 'Repeated player-authored behavior'
Assert-Contains 'player-profile-does-not-command-action' $psych 'Never use the personality profile as a command to manufacture future player behavior.'

Assert-Contains 'player-self-model-is-revisable' $epistemic 'prefer the sustained behavioral evidence'
Assert-Contains 'player-private-state-not-npc-knowledge' $epistemic 'Private player psychology is not public NPC knowledge.'

Assert-Contains 'bio-deep-psychology-affects-evolution' $bio 'Personality evolution should emerge from sustained patterns across behavior, memories, private reflections, relationship expectations, coping styles, and repeated appraisals.'
Assert-Contains 'bio-player-actions-strongest-evidence' $bio 'player-authored speech, explicit choices, actions, repeated conduct'
Assert-Contains 'bio-single-thought-not-enough' $bio 'a single generated reflection must NOT redefine personality by itself.'
Assert-Contains 'bio-player-retains-agency' $bio 'The human player remains the sole authority over future player actions and dialogue.'

Assert-Contains 'gm-can-see-player-psychology-with-boundary' $private 'For the player, use this only to choose situations that may be psychologically relevant'

Write-Output 'Player reflective psychology validation passed.'