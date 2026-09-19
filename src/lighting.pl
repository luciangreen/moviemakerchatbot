:- module(lighting, [lighting_profile/2]).

lighting_profile(sunset, [warm_backlight,golden_rim]).
lighting_profile(night, [cool_moonlight,neon_fill]).
lighting_profile(_, [neutral_key]).
