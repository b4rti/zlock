
-- Asset Class
CoreAsset = {
    name = 'core',
    description = 'zlock core assets',
    version = '0.0.1',
}
registerAsset(CoreAsset)

-- Handler Classes
CorePlayerHandler = {
    events = {
        'playerSpawn',
        'playerJoin',
        'playerDeath',
        'playerLeave',
        'playerWalk',
        'playerJump',
        'playerSneak',
        'playerInteract',
        'playerAttack',
        'playerHurt',
    },
}

function CorePlayerHandler.handleEvent(event)
end
-- registerHandler(CorePlayerHandler)

CoreMobHandler = {
    events = {
        'mobSpawn',
        'mobDeath',
        'mobWalk',
        'mobJump',
        'mobSneak',
        'mobInteract',
        'mobAttack',
        'mobHurt',
    },
}
function CoreMobHandler.handleEvent(event)
end
-- registerHandler(CoreMobHandler)

-- Block Classes
TestBlock = {
    name = 'testBlock',
    description = 'A test block.',
    duribility = 10,
    textures = {
        -- default
        all = '',
        -- overwrites
        left = '',
        right = '',
        front = '',
        back = '',
        top = '',
        bottom = '',
    },
    sounds = {
        step = {'', '', ''},
        place = {'', '', ''},
        breake = {'', '', ''},
    },
}
-- registerBlock(TestBlock)