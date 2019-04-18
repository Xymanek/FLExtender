class X2DownloadableContentInfo_FLExtender extends X2DownloadableContentInfo;

var config bool DO_NOT_PATCH_SCHEDULES;
var config bool DO_NOT_PATCH_DISTRIBUTION_LISTS;
var config bool DO_NOT_PATCH_ENCOUNTERS;

static event OnPostTemplatesCreated()
{
	if (GetMaxFL() <= 20)
	{
		`RedSceen("FLExtender enabled but max FL is 20 or lower");
		`warn("Max FL is 20 or lower",, 'FLExtender');
		return;
	}

	PatchSchedules();
	PatchDistributionLists();
	PatchEncounters();
}

static function int GetMaxFL()
{
	return class'XComGameState_HeadquartersAlien'.default.AlienHeadquarters_MaxForceLevel;
}

static function PatchSchedules()
{
	local XComTacticalMissionManager MissionManager;
	local MissionSchedule Schedule;
	local int MaxFL, i;

	if (DO_NOT_PATCH_SCHEDULES)
	{
		return;
	}

	`log("Patching schedules",, 'FLExtender');

	MissionManager = `TACTICALMISSIONMGR;
	MaxFL = GetMaxFL();

	for (i = 0; i < MissionManager.MissionSchedules.Length; i++)
	{
		Schedule = MissionManager.MissionSchedules[i];

		if (Schedule.MaxRequiredForceLevel >= 20)
		{
			Schedule.MaxRequiredForceLevel = MaxFL;

			MissionManager.MissionSchedules[i] = Schedule;
		}
	}
}

static function PatchDistributionLists()
{
	local XComTacticalMissionManager MissionManager;
	local int MaxFL, i, j;
	
	if (DO_NOT_PATCH_DISTRIBUTION_LISTS)
	{
		return;
	}

	`log("Patching SpawnDistributionLists entries",, 'FLExtender');

	MissionManager = `TACTICALMISSIONMGR;
	MaxFL = GetMaxFL();

	for (i = 0; i < MissionManager.SpawnDistributionLists.Length; i++)
	{
		for (j = 0; j < MissionManager.SpawnDistributionLists[i].SpawnDistribution.Length; j++)
		{
			if (MissionManager.SpawnDistributionLists[i].SpawnDistribution[j].MaxForceLevel >= 20)
			{
				MissionManager.SpawnDistributionLists[i].SpawnDistribution[j].MaxForceLevel = MaxFL;
			}
		}
	}
}

static function PatchEncounters()
{
	local XComTacticalMissionManager MissionManager;
	local int MaxFL, i;
	
	if (DO_NOT_PATCH_ENCOUNTERS)
	{
		return;
	}

	`log("Patching ConfigurableEncounters entries",, 'FLExtender');

	MissionManager = `TACTICALMISSIONMGR;
	MaxFL = GetMaxFL();

	for (i = 0; i < MissionManager.ConfigurableEncounters.Length; i++)
	{
		if (MissionManager.ConfigurableEncounters[i].MaxRequiredForceLevel >= 20)
		{
			MissionManager.ConfigurableEncounters[i].MaxRequiredForceLevel = MaxFL;
		}
	}
}