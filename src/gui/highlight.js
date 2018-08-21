Prism.languages.code = {
	'comment': [
		{
			pattern: /(^|[^\\])\/\*[\s\S]*?(?:\*\/|$)/,
			lookbehind: true
		},
		{
			pattern: /(^|[^\\:])\/\/.*/,
			lookbehind: true,
			greedy: true
		}
	],
	'string': {
		pattern: /(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
		greedy: true
    },
    'keyword': /\b(?:globals|endglobals|library|endlibrary|struct|endstruct|scope|endscope|method|endmethod|interface|endinterface|function|endfunction|loop|endloop|if|then|else|elseif|endif|exitwhen|native|takes|returns|return|local|call|set|true|false|null|array|extends|type|constant|and|or|not|requires|needs|uses|initializer|public|private|static|defaults|operator|debug)\b/,
    'function': /\b(?:GetEnumDestructable|SetPlayerRaceSelectable|GetTimeOfDayScale|SetTutorialCleared|IsUnitDetected|SaveItemHandle|LoadTriggerEventHandle|IsQuestRequired|GetRevivingUnit|RemoveLocation|TriggerSyncStart|SetWidgetLife|TriggerRegisterPlayerEvent|ForceEnumAllies|RemoveRect|ConvertDamageType|StoreInteger|GetEventDamageSource|QuestSetCompleted|LoadRegionHandle|GetEventDetectingPlayer|SetUnitUserData|RemoveGuardPosition|LeaderboardSetValueColor|SetBlightPoint|IssuePointOrderByIdLoc|GetPlayers|GetUnitLoc|ChooseRandomCreep|SyncStoredReal|SetCineFilterEndUV|SetUnitTurnSpeed|SetUnitExploded|SaveMultiboardItemHandle|IsItemIdPowerup|ForceRemovePlayer|LeaderboardSortItemsByPlayer|ConvertGameDifficulty|EnableUserControl|UnitDamagePoint|UnitInventorySize|LoadStr|RegionAddCellAtLoc|CreateFogModifierRect|SetIntegerGameState|TriggerRegisterDialogButtonEvent|LoadItemHandle|LoadMultiboardItemHandle|UnitWakeUp|SetCinematicScene|GetExpiredTimer|SaveDestructableHandle|FlushStoredInteger|UnitDropItemTarget|DialogDestroy|IsHeroUnitId|SetStartLocPrio|FirstOfGroup|GetLocalizedString|SaveTimerDialogHandle|UnitRemoveItem|GroupPointOrderById|GetUnitAbilityLevel|ForceCinematicSubtitles|VersionGet|CreateDestructableZ|GetSellingUnit|TriggerWaitForSound|GetChangingUnit|PauseGame|AddHeroXP|DestructableRestoreLife|GetTriggerExecCount|SetDestructableOccluderHeight|ReviveHeroLoc|IsUnitIllusion|SetUbersplatRender|GetEnumPlayer|GetOrderTargetDestructable|SetUnitFlyHeight|NewSoundEnvironment|SaveDefeatConditionHandle|GetHeroLevel|SetMapFlag|GetSoldUnit|IsTimerDialogDisplayed|PanCameraToTimedWithZ|HaveSavedBoolean|SetUnitFacingTimed|SetThematicMusicPlayPosition|UnitRemoveBuffsEx|SaveReal|DestroyForce|ItemPoolRemoveItemType|LoadUnitPoolHandle|TriggerRegisterUnitInRange|IssueNeutralImmediateOrder|IsMapFlagSet|LeaderboardSetItemLabelColor|SetPlayerAlliance|GetClickedButton|IsPlayerInForce|SetCampaignMenuRaceEx|TimerDialogSetTimeColor|DestroyQuest|ConvertCameraField|SetSoundDuration|ChooseRandomNPBuilding|AddItemToStock|SetCineFilterStartUV|SetUnitRescuable|IssueInstantTargetOrder|SetUnitVertexColor|RecycleGuardPosition|EnableTrigger|MultiboardSetItemsValueColor|GetLightningColorR|ForcePlayerStartLocation|GetUnitFlyHeight|GetSpellTargetDestructable|IsQuestItemCompleted|GetUnitPropWindow|CameraSetupGetDestPositionX|ConvertAllianceType|GetLightningColorB|GetLightningColorA|GetLightningColorG|SetPlayerAbilityAvailable|PreloadGenEnd|SetDestructableInvulnerable|GetWinningPlayer|TriggerSyncReady|UnitSuspendDecay|HaveStoredString|TriggerRegisterEnterRegion|GetDestructableX|GetDestructableY|ForceUICancel|CopySaveGame|LoadBooleanExprHandle|ResetUbersplat|SetUnitPathing|SaveLightningHandle|CreateItem|DestroyFogModifier|ResetToGameCamera|IsUnitAlly|GetRevivableUnit|UnitSetUpgradeProgress|CameraSetupSetField|QueueDestructableAnimation|GetOrderTarget|GetOwningPlayer|IsUnitVisible|SaveForceHandle|MultiboardSetItemsWidth|TriggerRegisterGameStateEvent|AdjustCameraField|GroupEnumUnitsInRect|RemoveUnitFromAllStock|SetTerrainPathable|MultiboardSetItemWidth|ConvertRacePref|LoadButtonHandle|FlushParentHashtable|GetCameraBoundMinX|LoadTrackableHandle|SetAllyColorFilterState|CachePlayerHeroData|GetClickedDialog|ForGroup|VolumeGroupSetVolume|PlayThematicMusicEx|SaveStr|LeaderboardGetItemCount|GetRectCenterY|GetRectCenterX|HaveSavedHandle|TriggerRegisterTrackableTrackEvent|GetUnitMoveSpeed|GetFilterItem|I2R|I2S|PauseUnit|SetCineFilterBlendMode|GroupPointOrderByIdLoc|StopMusic|PlayModelCinematic|GetTeams|CreateRegion|GetConstructedStructure|MultiboardSetRowCount|ConvertFogState|HaveSavedString|AddSpellEffectTarget|GetEnumItem|ConvertBlendMode|HaveStoredBoolean|GetOrderTargetUnit|AddWeatherEffect|SetUbersplatRenderAlways|GroupImmediateOrderById|SetDestructableMaxLife|SetSoundDistanceCutoff|SetMusicPlayPosition|LoadEffectHandle|ConvertIGameState|QuestSetDescription|AddSpecialEffectTarget|IssueBuildOrderById|GetItemUserData|SetPlayerUnitsOwner|GetGameSpeed|LoadReal|SaveGameCache|SetUnitState|EnableUserUI|Or|GetBuyingUnit|SaveGame|KillDestructable|IsItemIdSellable|DestroyTextTag|IsFogEnabled|IsMaskedToPlayer|DestroyUbersplat|GetItemType|SetItemPawnable|SaveItemPoolHandle|EnableSelect|SaveFogModifierHandle|GetUnitX|GetUnitY|GroupEnumUnitsInRange|UnitIsSleeping|SetSoundVelocity|IsPointBlighted|IsNoVictoryCheat|GetTriggerDestructable|IsUnitInRegion|RemoveAllGuardPositions|TimerGetElapsed|IssueNeutralPointOrderById|Cheat|GetAbilitySoundById|SetTerrainType|SetIntroShotText|GetHeroSkillPoints|GetCameraEyePositionLoc|SetSoundPitch|OrderId2String|GetTriggerPlayer|GetTrainedUnitType|CreateForce|SetUnitOwner|SetPlayerHandicap|SetDestructableLife|DestroyBoolExpr|SaveDialogHandle|IsQuestCompleted|MultiboardSetItemsIcon|GetUnitTypeId|CreateDeadDestructableZ|GetSpellAbility|FlushStoredMission|CreateMultiboard|GroupTargetOrder|SaveUbersplatHandle|CreateQuest|UnitHasItem|Sin|HaveSavedReal|StartSound|GetSpellTargetX|GetSpellTargetY|SetUnitTimeScale|ConvertFGameState|CameraSetupSetDestPosition|GetCustomCampaignButtonVisible|DoNotSaveReplay|IsDestructableInvulnerable|IsItemPowerup|DialogAddButton|CameraSetupGetDestPositionLoc|GetEventPlayerState|SetPlayerStartLocation|TimerDialogSetTitle|LoadHashtableHandle|SetPlayerTaxRate|CameraSetupApply|GetItemTypeId|AttachSoundToUnit|VersionCompatible|IsUnitRace|SetAllUnitTypeSlots|Tan|UnitUseItemPoint|EnableOcclusion|LoadTimerDialogHandle|GetHeroStr|DisplayTimedTextFromPlayer|KillUnit|GetStoredString|RemoveRegion|DestroyTimerDialog|CameraSetTargetNoiseEx|IsLocationVisibleToPlayer|SaveBoolean|IsCineFilterDisplayed|IsUnit|SetSoundChannel|SetPlayerOnScoreScreen|Atan2|TerrainDeformWave|GetRescuer|PreloadRefresh|GetPlayerId|SaveWidgetHandle|SetTextTagSuspended|CommandAI|IsItemVisible|GetManipulatedItem|LoadPlayerHandle|SetPlayerTechMaxAllowed|SetHeroLevel|MoveLocation|TriggerRegisterTimerExpireEvent|SetPlayerRacePreference|UnitMakeAbilityPermanent|PauseTimer|UnitShareVision|ConvertVolumeGroup|PanCameraToTimed|ConvertVersion|SaveTextTagHandle|UnitItemInSlot|CripplePlayer|GetEventUnitState|FlushStoredString|CameraSetupApplyWithZ|GetLearnedSkillLevel|SetUnitMoveSpeed|SetPlayerColor|SaveQuestItemHandle|IssueInstantPointOrder|Preload|GetStoredBoolean|ConvertPlayerGameResult|GetWidgetLife|GetCameraBoundMinY|IsLocationMaskedToPlayer|SelectUnit|CreateTimer|SetPlayerTechResearched|LoadItemPoolHandle|SetSoundConeAngles|GetItemPlayer|IsSuspendedXP|UnitDropItemPoint|LoadQuestHandle|SelectHeroSkill|CreateFogModifierRadiusLoc|SaveInteger|SavePlayerHandle|SaveTriggerEventHandle|IssueBuildOrder|GetLeavingUnit|TriggerRegisterUnitEvent|WaygateIsActive|GetAttacker|SetImageRender|GetEventGameState|GetSoldItem|SaveGroupHandle|FlashQuestDialogButton|SetDestructableAnimation|GroupImmediateOrder|MultiboardGetItem|PanCameraTo|EnablePreSelect|GetSelectedUnit|GetHeroAgi|SetImagePosition|StringCase|GetRandomInt|GetPlayerTechMaxAllowed|SetCreatureDensity|SetAltMinimapIcon|SetPlayerHandicapXP|Asin|ConvertAttackType|DialogCreate|SetItemCharges|EnableWeatherEffect|DecUnitAbilityLevel|TriggerSleepAction|ConvertMapFlag|TriggerRegisterFilterUnitEvent|SetTextTagAge|ForceCampaignSelectScreen|GetOrderedUnit|GetTriggerWidget|SetGameSpeed|MoveRectToLoc|LoadTextTagHandle|IsUnitFogged|GetUnitDefaultMoveSpeed|SetWaterDeforms|IsLeaderboardDisplayed|GroupPointOrderLoc|TriggerRegisterTrackableHitEvent|MultiboardSetItemsValue|ClearMapMusic|SetHeroInt|CreateSound|SetTextTagPosUnit|PreloadEndEx|S2I|S2R|GetDestructableName|ConvertDialogEvent|LoadLightningHandle|SetUnitAnimation|LoadLeaderboardHandle|GetSoundFileDuration|DialogClear|SyncStoredBoolean|UnitAddItemToSlotById|ForceUIKey|ConvertUnitEvent|SetItemDropOnDeath|GetResourceAmount|IssueNeutralTargetOrder|LeaderboardSortItemsByLabel|PlaceRandomUnit|ShowDestructable|LeaderboardSetStyle|SetTextTagFadepoint|CreateBlightedGoldmine|GetLocalPlayer|GetUnitDefaultPropWindow|RemoveItem|SaveRectHandle|CreateTextTag|SetCameraTargetController|ConvertPlayerColor|SetSoundPlayPosition|SetUnitBlendTime|Location|GetEventDamage|GroupEnumUnitsInRangeOfLocCounted|SetUnitAnimationByIndex|SetUnitRescueRange|IsItemPawnable|SetResourceDensity|GetCreatureDensity|SetCineFilterTexMapFlags|SetTerrainFogEx|R2SW|GroupEnumUnitsInRangeCounted|IsItemSellable|GetUnitCurrentOrder|SetPlayerController|FlushStoredUnit|TriggerRegisterUnitStateEvent|UnitResetCooldown|GetStoredReal|RemoveSavedHandle|RemoveSavedBoolean|ConvertMapVisibility|FlushGameCache|IsMultiboardMinimized|IsTerrainPathable|UnitRemoveAbility|FlushChildHashtable|FogMaskEnable|RemoveUnit|TriggerRegisterGameEvent|ItemPoolAddItemType|QueueUnitAnimation|RestoreUnit|StartCampaignAI|GetCameraEyePositionX|UnitIgnoreAlarmToggled|R2S|CreateDestructable|SetOpCinematicAvailable|GetDestructableTypeId|RemovePlayer|MultiboardSetItemValueColor|UnitId|SetMapDescription|SetTerrainFog|MultiboardSetColumnCount|UnitModifySkillPoints|GetAllyColorFilterState|LeaderboardAddItem|IssueTargetOrder|AddSpellEffectLoc|SetUnitColor|SetSkyModel|MoveLightningEx|GetTriggerEventId|ChooseRandomItem|IsUnitSelected|GetSpellTargetItem|GetDestructableOccluderHeight|GetTrainedUnit|TriggerAddAction|RegisterStackedSound|GroupPointOrder|TriggerRegisterDialogEvent|RegionClearRect|IsUnitInRangeXY|GetPlayerTeam|IssueNeutralImmediateOrderById|DestroyLightning|LoadInteger|GetDecayingUnit|SyncSelections|GetAbilitySound|IsUnitInTransport|LoadBoolean|GetOrderTargetItem|GetUnitPointValue|GetUnitUserData|SetPlayers|SetItemDropID|ShowUnit|StoreString|GetGameTypeSelected|GetFoodUsed|UnitPoolRemoveUnitType|SetTextTagLifespan|LoadTriggerHandle|LeaderboardRemovePlayerItem|LeaderboardSetItemStyle|GetIntegerGameState|ConvertPlacement|UnitCanSleepPerm|GetTransportUnit|LoadSoundHandle|SetUnitAcquireRange|SetUnitCreepGuard|SetDoodadAnimationRect|GetPlayerRace|GetStartLocationX|GetStartLocationY|GetUnitState|StopCamera|SubString|IsUnitPaused|HaveStoredReal|UnitIgnoreAlarm|ShowImage|LoadAbilityHandle|TriggerRegisterPlayerUnitEvent|SetCineFilterEndColor|ConvertStartLocPrio|ConvertAIDifficulty|UnitAddIndicator|ResetUnitLookAt|WaygateActivate|DefineStartLocation|ClearSelection|GetItemY|GetItemX|TimerDialogDisplay|StartMeleeAI|CameraSetupApplyForceDurationWithZ|IsUnitInvisible|MultiboardGetRowCount|SetTeams|KillSoundWhenDone|DestroyTimer|GetLearningUnit|SetMapName|RegionClearCellAtLoc|GetAbilityEffect|SetUnitScale|DialogSetMessage|GetSpellAbilityId|GetPlayerAlliance|SetDoodadAnimation|SaveTriggerHandle|UnitAddItem|ConvertUnitState|UnitAddItemById|GetDestructableMaxLife|CameraSetTargetNoise|SetSoundConeOrientation|MoveLightning|LeaderboardGetPlayerIndex|UnitAddSleepPerm|SetGameTypeSupported|SetGameDifficulty|IsUnitInGroup|GetRandomReal|IsPlayerRacePrefSet|SaveSoundHandle|EndGame|RemoveWeatherEffect|SyncStoredUnit|UnitId2String|HaveStoredInteger|InitGameCache|TimerGetTimeout|IncUnitAbilityLevel|GetLoadedUnit|SetWaterBaseColor|StoreReal|SaveButtonHandle|SetUnitUseFood|SetItemDroppable|Acos|SyncStoredInteger|EnumItemsInRect|IssueTargetOrderById|MultiboardReleaseItem|SaveLocationHandle|GetCameraMargin|QuestCreateItem|CreateDefeatCondition|SetUnitAbilityLevel|GetTriggerEvalCount|IsTriggerWaitOnSleeps|PanCameraToWithZ|Rad2Deg|CreateUbersplat|SetStartLocPrioCount|QuestSetEnabled|LoadGroupHandle|GetAbilityEffectById|LoadUbersplatHandle|SetItemInvulnerable|OrderId|CameraSetSourceNoiseEx|EnableDragSelect|CreateUnitByName|Player|GetPlayerTechCount|GetPlayerScore|Preloader|StringLength|RemoveSavedReal|SetUnitPosition|SetSoundPosition|LeaderboardSetLabelColor|CreateImage|LoadUnitHandle|SetTextTagColor|SetDayNightModels|SaveRegionHandle|GroupAddUnit|IsLocationInRegion|DestroyImage|SetDestructableAnimationSpeed|GetPlayerStartLocation|MultiboardSetTitleTextColor|GroupEnumUnitsOfType|GetSpellTargetUnit|GetLevelingUnit|GroupEnumUnitsInRectCounted|MultiboardDisplay|AddLightningEx|GetPlayerTechResearched|GetItemName|ForceQuestDialogUpdate|UnitCanSleep|LeaderboardSetItemValue|TriggerRegisterPlayerChatEvent|ConvertRace|GroupRemoveUnit|ForceAddPlayer|ForceEnumPlayersCounted|InitHashtable|LeaderboardRemoveItem|GetFoodMade|ShowInterface|GetPlayerSlotState|GetSoundIsLoading|EnableWorldFogBoundary|LoadTriggerConditionHandle|SaveAbilityHandle|LoadLocationHandle|HaveStoredUnit|GetPlayerHandicapXP|SetDefaultDifficulty|LeaderboardSetItemValueColor|LoadImageHandle|LeaderboardSetLabel|GetCameraBoundMaxY|GetCameraBoundMaxX|CreateLeaderboard|GetAIDifficulty|SaveTriggerConditionHandle|FinishUbersplat|TerrainDeformRipple|DialogDisplay|AddUnitAnimationProperties|AbilityId2String|ForceClear|ConvertPlayerSlotState|LeaderboardDisplay|ForceEnumEnemies|GetSummoningUnit|CreateUnitPool|LoadFogStateHandle|SetBlightLoc|SetAllItemTypeSlots|GetFilterPlayer|QuestItemSetDescription|SetUnitAnimationWithRarity|ChooseRandomItemEx|Atan|GetUnitRace|SetPlayerName|AddSpellEffectTargetById|MultiboardSuppressDisplay|PreloadStart|EnableMinimapFilterButtons|Rect|LoadTimerHandle|AddLightning|GetPlayerController|ForForce|DestroyFilter|DestroyGroup|LoadTriggerActionHandle|UnitAddSleep|MultiboardSetItemsStyle|SetHeroStr|SetMapMusic|UnitSetUsesAltIcon|UnitAddAbility|GetLocationY|GetLocationX|TerrainDeformCrater|MultiboardGetTitleText|GetUnitFacing|ChangeLevel|StoreBoolean|DialogAddQuitButton|DestroyCondition|GetStartLocPrio|PauseCompAI|CameraSetupApplyForceDuration|SetCampaignAvailable|TriggerRegisterLeaveRegion|LoadDestructableHandle|RemoveSavedString|GetPlayerTaxRate|UnitPoolAddUnitType|IssueNeutralPointOrder|LeaderboardGetLabelText|GetPlayerTypedUnitCount|GetSoundDuration|LeaderboardSetSizeByItemCount|MultiboardClear|TriggerRegisterVariableEvent|GetRectMaxY|GetRectMaxX|GetDetectedUnit|CreateUnit|SetBlightRect|MultiboardGetColumnCount|EndThematicMusic|ConvertPathingType|ExecuteFunc|UnitDropItemSlot|SetPlayerState|IssuePointOrderLoc|ShowUbersplat|UnitAddType|IsPlayerObserver|GetCancelledStructure|Cos|LoadForceHandle|DefineStartLocationLoc|SetCineFilterTexture|LoadMultiboardHandle|GetTournamentFinishSoonTimeRemaining|SetFogStateRect|PingMinimap|StopSound|GetIssuedOrderId|RenameSaveDirectory|PlayerSetLeaderboard|GetDestructableLife|GetPlayerStructureCount|RemoveUnitFromStock|IsGameTypeSupported|TimerDialogSetRealTimeRemaining|SetItemTypeSlots|IssuePointOrderById|SetTextTagText|SetImageColor|AddResourceAmount|SaveImageHandle|GroupEnumUnitsInRangeOfLoc|ConvertSoundType|FlushStoredBoolean|GetDefaultDifficulty|GetUnitFoodMade|GetStoredInteger|IsUnitInForce|DisplayCineFilter|AddSpecialEffectLoc|SetUnitPointValueByType|DisableTrigger|CameraSetupGetField|SaveUnitPoolHandle|ClearTextMessages|SaveMultiboardHandle|SetTextTagVelocity|DestroyTrigger|GetPlayerState|ConvertGameSpeed|RegionClearCell|RestartGame|SetTextTagPos|AddSpecialEffect|AddSpellEffect|UnitRemoveItemFromSlot|SaveTriggerActionHandle|SetItemUserData|QuestSetIconPath|RegionAddCell|ForceEnumPlayers|GetRectMinY|GetRectMinX|CameraSetSmoothingFactor|TerrainDeformStop|GetLocalizedHotkey|Filter|LoadRectHandle|CreateItemPool|DestroyLeaderboard|QuestSetFailed|FogModifierStop|R2I|GetSpellAbilityUnit|SuspendTimeOfDay|CreateTrigger|GetCameraEyePositionZ|IssueInstantTargetOrderById|GetCameraEyePositionY|GetUnitRallyDestructable|SetItemVisible|SetSoundParamsFromLabel|GetPlayerName|SetUnitPropWindow|GetCameraTargetPositionLoc|GroupTargetOrderById|ResetTerrainFog|WaygateSetDestination|GetTriggeringTrackable|SetFogStateRadius|SetResourceAmount|LoadDefeatConditionHandle|LeaderboardClear|GetOrderPointLoc|GetUnitPointValueByType|SetUnitPositionLoc|CreateUnitAtLocByName|TriggerRegisterTimerEvent|ConvertPlayerUnitEvent|GetTriggeringTrigger|GetItemCharges|CameraSetSourceNoise|SetSoundVolume|SetUnitX|SetUnitY|AbilityId|SaveTrackableHandle|TriggerClearConditions|GetSummonedUnit|GetGameDifficulty|Not|SetImageType|GetObjectName|UnitSetConstructionProgress|LoadGame|ReviveHero|TimerDialogSetTitleColor|TriggerClearActions|ResetTrigger|MultiboardSetItemIcon|DisplayTimedTextToPlayer|IsFoggedToPlayer|SetCameraOrientController|QuestItemSetCompleted|GetUnitRallyUnit|IssueInstantPointOrderById|GetUnitTurnSpeed|RemoveItemFromStock|GetTerrainType|QuestSetRequired|CreateTimerDialog|TriggerWaitOnSleeps|IsUnitIdType|GetHandleId|IsUnitInRangeLoc|GetTriggerUnit|ReloadGame|PreloadGenClear|GetDyingUnit|EndCinematicScene|CreateCameraSetup|MultiboardSetItemStyle|GetEnteringUnit|IsUnitLoaded|SaveTimerHandle|ConvertWidgetEvent|GetCameraTargetPositionY|GetCameraTargetPositionX|GetCameraTargetPositionZ|GroupEnumUnitsOfTypeCounted|TriggerRemoveAction|AddUnitToStock|GetPlayerSelectable|SetCustomCampaignButtonVisible|SaveEffectHandle|IsNoDefeatCheat|ConvertPlayerState|GetResearched|IsUnitHidden|ConvertMapDensity|GetSpellTargetLoc|PlayMusic|IsQuestFailed|SaveUnitHandle|RemoveItemFromAllStock|ReloadGameCachesFromDisk|VolumeGroupReset|GetPlayerUnitCount|SaveLeaderboardHandle|RemoveSaveDirectory|EnumDestructablesInRect|GetKillingUnit|UnitRemoveBuffs|DisplayTextToPlayer|GetUnitRallyPoint|PingMinimapEx|FogModifierStart|GetGamePlacement|GetCreepCampFilterState|SaveFogStateHandle|SquareRoot|SaveQuestHandle|UnitStripHeroLevel|DestroyItemPool|GetTriggeringRegion|GetEventPlayerChatStringMatched|SetHeroAgi|AddSpellEffectByIdLoc|CreateDeadDestructable|CreateGroup|StoreUnit|LeaderboardSortItemsByValue|IsPointInRegion|Deg2Rad|ConvertMapControl|CreateTrackable|SetBlight|GetUnitName|FogEnable|ConvertRarityControl|TimerDialogSetSpeed|GetEventTargetUnit|ConvertUnitType|MoveRectTo|IsPlayerEnemy|UnitRemoveType|SuspendHeroXP|HaveSavedInteger|IssueImmediateOrderById|IsLocationFoggedToPlayer|AddIndicator|GroupEnumUnitsOfPlayer|SetReservedLocalHeroButtons|ConvertEffectType|ConvertItemType|ConvertMapSetting|SetUnitFog|CameraSetupGetDestPositionY|PlayMusicEx|GetTournamentScore|IssueNeutralTargetOrderById|Condition|SetImageAboveWater|GetSaveBasicFilename|DestroyMultiboard|ResumeTimer|CreateCorpse|IsTriggerEnabled|SetCameraRotateMode|SetCinematicCamera|SetUnitTypeSlots|SetRectFromLoc|IssueImmediateOrder|IssuePointOrder|SetCampaignMenuRace|PlayCinematic|PreloadEnd|SetFloatGameState|LoadWidgetHandle|LoadDialogHandle|Pow|SetCameraPosition|PlayerGetLeaderboard|RemoveSavedInteger|GetUnitDefaultTurnSpeed|SaveGameExists|GetLocationZ|LoadFogModifierHandle|GroupEnumUnitsSelected|FlushStoredReal|DestroyEffect|GetPlayerColor|DefeatConditionSetDescription|GetChangingUnitPrevOwner|GetFloatGameState|DestroyUnitPool|PreloadGenStart|GetWorldBounds|ConvertGameEvent|DestroyDefeatCondition|AddUnitToAllStock|IsUnitOwnedByPlayer|SetMissionAvailable|VersionSupported|SetGamePlacement|GetUnitFoodUsed|SetUnitInvulnerable|GetEnumUnit|GetWidgetX|GetWidgetY|AddItemToAllStock|AddSpellEffectById|SaveAgentHandle|TimerStart|CreateSoundFromLabel|GetSoundIsPlaying|SetCineFilterDuration|TriggerEvaluate|StringHash|GetFilterDestructable|TerrainDeformRandom|CreateMIDISound|GetTerrainVariance|TriggerRegisterDeathEvent|IsItemIdPawnable|SetCreepCampFilterState|ConvertWeaponType|QuestSetDiscovered|SetLightningColor|IsVisibleToPlayer|And|IsUnitEnemy|RegionAddRect|SetSoundDistances|SaveHashtableHandle|MultiboardMinimize|SetTimeOfDayScale|ConvertLimitOp|SetCameraField|SetPlayerTeam|SetTextTagPermanent|RemoveDestructable|LeaderboardSetItemLabel|GetPlayerHandicap|AddPlayerTechResearched|SetCineFilterStartColor|IsUnitType|SetEdCinematicAvailable|IsQuestDiscovered|GroupClear|TriggerAddCondition|SetImageConstantHeight|DisableRestartMission|GetFilterUnit|TriggerRemoveCondition|UnitDamageTarget|UnitApplyTimedLife|ConvertGameType|SetRandomSeed|TimerGetRemaining|SetHeroXP|GetHeroProperName|SetCameraQuickPosition|SetUnitFacing|IsQuestEnabled|QuestSetTitle|GetStartLocationLoc|MultiboardSetTitleText|UnitUseItemTarget|ResumeMusic|SetItemPlayer|ConvertPlayerScore|SetIntroShotModel|GetLearnedSkill|GetUnitAcquireRange|IsUnitInRange|GetConstructingStructure|UnitCountBuffsEx|CreateSoundFilenameWithLabel|WaygateGetDestinationX|WaygateGetDestinationY|UnitUseItem|IsItemInvulnerable|SyncStoredString|GetUnitDefaultFlyHeight|GetItemLevel|UnitHasBuffsEx|TriggerExecute|PlayThematicMusic|ConvertTexMapFlags|SetMusicVolume|GetStartLocPrioSlot|TriggerExecuteWait|LoadQuestItemHandle|ConvertPlayerEvent|GetTournamentFinishNowPlayer|TerrainDeformStopAll|GetUnitLevel|RectFromLoc|MultiboardSetItemValue|GetCameraField|SetItemPosition|GetHeroInt|GetHeroXP|IsItemOwned|CreateFogModifierRadius|SetImageRenderAlways|CreateUnitAtLoc|SetCameraBounds|GetResearchingUnit|SetTextTagVisibility|SetUnitLookAt|SetFogStateRadiusLoc|PlaceRandomItem|DisplayLoadDialog|UnregisterStackedSound|GetTournamentFinishNowRule|LeaderboardHasPlayerItem|TriggerRegisterPlayerAllianceChange|IsFogMaskEnabled|GetManipulatingUnit|UnitPauseTimedLife|GetOrderPointX|GetOrderPointY|IsUnitMasked|IsMultiboardDisplayed|TriggerRegisterPlayerStateEvent|IsPlayerAlly|SetRect|GetTerrainCliffLevel|SaveBooleanExprHandle|GetEventPlayerChatString|GetUnitDefaultAcquireRange|GetResourceDensity)\b/,
    'operator': /[-+*]|\/|<[<=]?|>[>=]?|[=!]=?/,
    'number': /\b0x[a-f\d]+\.?[a-f\d]*(?:p[+-]?\d+)?\b|\b\d+(?:\.\B|\.?\d*(?:e[+-]?\d+)?\b)|\B\.\d+(?:e[+-]?\d+)?\b/i,
    'punctuation': /[\[\](),]/
};