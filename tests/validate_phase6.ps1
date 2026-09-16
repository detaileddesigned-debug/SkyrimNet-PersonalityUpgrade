$ErrorActionPreference = 'Stop'

function Read-Text([string]$Path) {
    return [IO.File]::ReadAllText((Resolve-Path $Path), [Text.Encoding]::UTF8)
}

function Assert-Contains([string]$Name, [string]$Text, [string]$Needle) {
    if (-not $Text.Contains($Needle)) {
        throw "FAIL [$Name]: missing expected policy text: $Needle"
    }
    Write-Output "PASS [$Name]"
}

function Assert-NotContains([string]$Name, [string]$Text, [string]$Needle) {
    if ($Text.Contains($Needle)) {
        throw "FAIL [$Name]: forbidden legacy wording still present: $Needle"
    }
    Write-Output "PASS [$Name]"
}

$psych = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/submodules/guidelines/0600_psychological_realism.prompt'
$epistemic = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/submodules/guidelines/0610_epistemic_boundaries.prompt'
$story = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/intel_story_dm.prompt'
$npcStory = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/intel_story_npc_dm.prompt'
$memory = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/memory/memory_builder.prompt'
$political = Read-Text 'SKSE/Plugins/SkyrimNet/prompts/intel_political_dm.prompt'

# 1. Awkward social event: allow convergence without forced sameness.
Assert-Contains 'awkward-social-natural-convergence' $epistemic 'Do not force artificial disagreement for variety.'
Assert-Contains 'awkward-social-individual-appraisal' $psych 'The same event may reasonably mean different things to different people'

# 2. Private secret shared: world fact stays concrete; private memory can adapt.
Assert-Contains 'secret-shared-concrete-fact' $epistemic 'she told the Jarl information he asked her to keep private'
Assert-Contains 'secret-shared-lasting-adaptation' $memory 'lasting expectation, caution, trust, resentment, affection, or other adaptation'

# 3. Jealous follower: jealousy may select the event but cannot leak into narration.
Assert-Contains 'jealous-follower-private-selection' $story 'Private memories, emotions, personality, and relationship state MAY determine which story is selected'
Assert-NotContains 'jealous-follower-no-leak' $story 'out of jealousy'

# 4. Gossip: listener receives an attributed claim rather than objective judgment.
Assert-Contains 'gossip-attribution' $npcStory 'gossip` is a reported claim, not authoritative world truth'
Assert-Contains 'gossip-listener-agency' $npcStory 'The listener may believe, doubt, reinterpret, or ignore it later.'

# 5. Player behavior: no canonical player personality.
Assert-Contains 'player-no-canonical-personality' $epistemic 'The player has no canonical hidden personality for NPCs to read.'
Assert-Contains 'player-different-models' $epistemic 'Different characters may reasonably form different models of the player from the same evidence.'

# 6. Repair after conflict: repair is not a reset.
Assert-Contains 'repair-not-reset' $psych 'Repair or forgiveness need not erase learned caution, resentment, attraction, affection, or other remaining attitudes.'

# Authoritative political/world knowledge hardening.
Assert-Contains 'political-world-knowledge-strict' $political 'Treat `world_knowledge` as the strictest factual layer'
Assert-Contains 'political-hidden-cause-private' $political 'That private cause must not automatically become part of the public `description` or authoritative `world_knowledge` interpretation.'
Assert-NotContains 'political-no-desperate-fury' $political 'fought with desperate fury'

Write-Output 'Phase 6 static integration validation passed.'