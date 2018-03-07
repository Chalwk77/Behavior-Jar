local media = {}

media.isSoundOn = true
media.isMusicOn = true

local sounds = {
    coindrop1 = '/assets/sounds/coindrop1.mp3',
    coindrop2 = '/assets/sounds/coindrop2.mp3',
    coindrop3 = '/assets/sounds/coindrop3.mp3',
    coindrop4 = '/assets/sounds/coindrop4.mp3',
    coindrop5 = '/assets/sounds/coindrop5.mp3',
    coindrop6 = '/assets/sounds/coindrop6.mp3',
    takeaway = '/assets/sounds/takeaway.wav'
}

local audioChannel, otherAudioChannel, currentStreamSound = 1, 2
function media.playStream(sound, force)
    if not media.isMusicOn then return end
    if not sounds[sound] then
        print('sounds: no such sound: ' .. tostring(sound))
        return
    end
    sound = sounds[sound]
    if currentStreamSound == sound and not force then return end
    audio.fadeOut({channel = audioChannel, time = 1000})
    audioChannel, otherAudioChannel = otherAudioChannel, audioChannel
    audio.setVolume(0.5, {channel = audioChannel})
    audio.play(audio.loadStream(sound), {channel = audioChannel, loops = -1, fadein = 1000})
    currentStreamSound = sound
end
audio.reserveChannels(2)

local loadedSounds = {}
local function loadSound(sound)
    if not loadedSounds[sound] then
        loadedSounds[sound] = audio.loadSound(sounds[sound])
    end
    return loadedSounds[sound]
end

function media.play(sound, params)
    if not media.isSoundOn then return end
    if not sounds[sound] then
        print('sounds: no such sound: ' .. tostring(sound))
        return
    end
    return audio.play(loadSound(sound), params)
end

function media.stop()
    currentStreamSound = nil
    audio.stop()
end

return media
