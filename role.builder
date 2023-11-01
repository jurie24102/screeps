var roleBuilder = {
    /** @param {Creep} creep **/
    run: function(creep) {
        if(creep.memory.building && creep.store[RESOURCE_ENERGY] == 0) {
            creep.memory.building = false;
            creep.say('🔁 harvest');
        }
        if(!creep.memory.building && creep.store.getFreeCapacity() == 0) {
            creep.memory.building = true;
            creep.say('🏗 build');
        }

        if(creep.memory.building) {
            // Find all construction sites that are containers
            var containerSites = creep.room.find(FIND_CONSTRUCTION_SITES, {
                filter: (site) => {
                    return site.structureType == STRUCTURE_CONTAINER;
                }   
            });
            // If there are container sites, build nearest one
            if(containerSites.length > 0){
                if(creep.build(containerSites[0]) == ERR_NOT_IN_RANGE) {
                    creep.moveTo(containerSites[0], {visualizePathStyle: {stroke: '#ffffff'}});
                }
            } else {
                // No container sites found. Build non-wall/rampart structures in order
                var otherTargets = creep.room.find(FIND_CONSTRUCTION_SITES, {
                    filter: (site) => {
                        return site.structureType !== STRUCTURE_WALL && site.structureType !== STRUCTURE_RAMPART;
                    }   
                });
                // Sort by priority structureType (first road->then extension...)
                if(otherTargets.length > 0){
                    otherTargets.sort((a, b) => a.structureType.localeCompare(b.structureType));
                    // Build nearest target                              
                    if(creep.build(otherTargets[0]) == ERR_NOT_IN_RANGE) {
                        creep.moveTo(otherTargets[0], {visualizePathStyle: {stroke: '#ffffff'}});
                    }
                }
            }
        } else {
            var sources = creep.room.find(FIND_SOURCES);
            if(creep.harvest(sources[0]) == ERR_NOT_IN_RANGE) {
                creep.moveTo(sources[0], {visualizePathStyle: {stroke: '#ffaa00'}});
            }
        }
    }
};
module.exports = roleBuilder;
