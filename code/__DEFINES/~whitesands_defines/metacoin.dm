/// Rewarded when you complete all your objectives as a traitor
#define METACOIN_GREENTEXT_REWARD(is_speed_round, round_duration) is_speed_round ? 250 : min(round(500 * (round_duration / 172800)), 250)
/// Rewarded when you earn a medal
#define METACOIN_MEDAL_REWARD(is_speed_round, round_duration) is_speed_round ? 150 : min(round(300 * (round_duration / 172800)), 150)
/// Rewarded when you complete a crew objective
#define METACOIN_CO_REWARD(is_speed_round, round_duration) is_speed_round ? 50 : min(round(100 * (round_duration / 172800)), 50)
/// Rewarded when you escape on the shuttle
#define METACOIN_ESCAPE_REWARD(is_speed_round, round_duration) is_speed_round ? 100 : min(round(200 * (round_duration / 172800)), 100)
/// Rewarded when you survive the round
#define METACOIN_SURVIVE_REWARD(is_speed_round, round_duration) is_speed_round ? 50 : min(round(100 * (round_duration / 172800)), 50)
/// Rewarded when you don't survive the round, but stick around till the end
#define METACOIN_NOTSURVIVE_REWARD       30
/// Rewarded when you are alive and active for 10 minutes
#define METACOIN_TENMINUTELIVING_REWARD  10
