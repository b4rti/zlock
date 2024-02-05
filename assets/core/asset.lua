---@diagnostic disable: undefined-global

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
registerHandler(CorePlayerHandler)


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
registerHandler(CoreMobHandler)


-- Block Classes
CoreTestBlock = {
    name = 'testBlock',
    id = 'core:testBlock',
    description = 'A test block.',
    duribility = 10,
    textures = {
        -- default
        all = 'defaultTexture',
        -- overwrites
        left = 'leftTexture',
        right = 'rightTexture',
        front = 'frontTexture',
        back = 'backTexture',
        top = 'topTexture',
        bottom = 'bottomTexture',
    },
    sounds = {
        step = {'', '', ''},
        place = {'', '', ''},
        breake = {'', '', ''},
    },
    events = {
        'blockPlace',
        'blockHit',
        'blockBreak',
        'blockStep',
        'blockInteract',
    },
}
function CoreTestBlock.handleEvents(event)
end
registerBlock(CoreTestBlock)


-- Structure Classes
CoreTestStructure = {
    name = "testStructure",
    description = "A test structure",
    mappings = {
        X = 'core:testBlock',
    },
    structure = {
        {
            {'X', 'X', 'X'},
            {'X', 'X', 'X'},
            {'X', 'X', 'X'},
        },
        {
            {'X', 'X', 'X'},
            {'X', 'X', 'X'},
            {'X', 'X', 'X'},
        },
        {
            {'X', 'X', 'X'},
            {'X', 'X', 'X'},
            {'X', 'X', 'X'},
        },
    },
    events = {
        'structureCreate',
        'structureEnter',
        'structureExit',
    },
}
registerStructure(CoreTestStructure)