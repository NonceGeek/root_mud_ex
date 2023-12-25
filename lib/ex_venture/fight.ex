defmodule ExVenture.Fight do
    @moduledoc """
        Battle logic for ExVenture.
        see vitals in:
        > lib/kantele/character.ex

        character.meta.vitals
    """

    alias ExVenture.Characters
    
    def fight(character_1, character_2) do
        # TODO: impl battle logic.
        character_1_health_points = character_1.meta.vitals.health_points - 1
        character_2_health_points = character_2.meta.vitals.health_points - 1
        character_1 = update_character_with_health_points(character_1, character_1_health_points)
        character_2 = update_character_with_health_points(character_2, character_2_health_points)
        %{character_1: character_1, character_2: character_2}
    end

    def update_character_with_health_points(character, health_points) do
        vitals = Map.put(character.meta.vitals, :health_points, health_points)
        meta = Map.put(character.meta, :vitals, vitals)
        Map.put(character, :meta, meta)
    end

end