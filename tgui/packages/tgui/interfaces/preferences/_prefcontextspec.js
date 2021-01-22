// DO NOT MERGE THIS FILE!
// This file exists solely as an API reference while developing this PR
// It does not provide functionality or need testing.
const _common = () => {
  const Species = {
    traits: {
      agender: PropTypes.bool
    },
    use_skintones: PropTypes.bool
  };
};
const _CharacterSetup = () => {


  const CustomNamePreferenceDefine = {
    type: PropTypes.string,
    qdesc: PropTypes.string,
    allow_numbers: PropTypes.bool,
    group: PropTypes.string,
    allow_null: PropTypes.bool
  };

  const CustomNamePreferenceValue = {
    type: PropTypes.string,
    value: PropTypes.string
  };

  const CharacterSlot = {
    real_name: PropTypes.string,
    always_random_name: PropTypes.bool,
    always_random_antag_name: PropTypes.bool,
    always_random_gender: PropTypes.bool,
    always_random_antag_gender: PropTypes.bool,
    always_random_body: PropTypes.bool,
    always_random_antag_body: PropTypes.bool,
    gender: PropTypes.number,
    species: PropTypes.shape(Species),
    custom_name_prefs: PropTypes.objectOf(PropTypes.shape(CustomNamePreferenceValue)),
    ai_core_display: PropTypes.string,
    pref_sec_department: PropTypes.string,
    bag: PropTypes.string,
    suit: PropTypes.string,
    exo: PropTypes.string,
    uplink_loc: PropTypes.string
  };

  const CharacterSetupData = {
    banned: {
      appearance: PropTypes.bool
    },
    characters: PropTypes.arrayOf(
      PropTypes.shape(CharacterSlot)
    ),
    active_character: PropTypes.number,
    flags: {
      roundstart_traits: PropTypes.bool
    },
    pref_defines: {
      ai_core_display: PropTypes.arrayOf(PropTypes.string),
      sec_department: PropTypes.arrayOf(PropTypes.string),
      backpack_types: PropTypes.arrayOf(PropTypes.string),
      jumpsuit_styles: PropTypes.arrayOf(PropTypes.string),
      outerwear_styles: PropTypes.arrayOf(PropTypes.string),
      uplink_locations: PropTypes.arrayOf(PropTypes.string),
      custom_names: PropTypes.arrayOf(PropTypes.shape(CustomNamePreferenceDefine))
    }
  };

  const CharacterSetupActions = [{
      action: "randomize_name",
      payload: {
        slot: PropTypes.number
      }
    },
    {
      action: "update_real_name",
      payload: {
        slot: PropTypes.number,
        value: PropTypes.string
      }
    },
    {
      action: "select_gender",
      payload: {
        slot: PropTypes.number,
        value: PropTypes.number
      }
    },
    {
      action: "update_age",
      payload: {
        slot: PropTypes.number,
        value: PropTypes.number
      }
    },
    {
      action: "toggle_random",
      payload: {
        slot: PropTypes.number,
        type: PropTypes.string,
        antag: PropTypes.bool
      }
    },
    {
      action: "set_custom_name",
      payload: {
        slot: PropTypes.number,
        type: PropTypes.string,
        value: PropTypes.string
      }
    },
    {
      action: "set_ai_core_display",
      payload: {
        slot: PropTypes.number,
        value: PropTypes.string
      }
    },
    {
      action: "set_pref_sec_department",
      payload: {
        slot: PropTypes.number,
        value: PropTypes.string
      }
    }
  ];
}

const _CharacterAppearance = () => {
  const CharacterAppearanceActions = [
    {
      action: "random_body",
      payload: { slot: PropTypes.number }
    },
    {
      action: "toggle_random",
      payload: {
        slot: PropTypes.number, type: PropTypes.string
      }
    },
    {
      action: "select_species",
      payload: { slot: PropTypes.number, value: PropTypes.string }
    },
    {
      action: "random_species",
      payload: { slot: PropTypes.number }
    },
    {
      action: "select_underwear_variant",
      payload: { slot: PropTypes.number, value: PropTypes.string }
    },
    {
      action: "select_underwear_color",
      payload: { slot: PropTypes.number, value: PropTypes.string }
    },
    {
      action: "set_undershirt_variant",
      payload: { slot: PropTypes.number, value: PropTypes.string }
    },
    {
      action: "set_undersirt_color",
      payload: { slot: PropTypes.number, value: PropTypes.string }
    },
    {
      action: "set_socks_variant",
      payload: { slot: PropTypes.number, value: PropTypes.string }
    }
  ];
};
