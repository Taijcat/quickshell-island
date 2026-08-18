pragma Singleton
import QtQuick

QtObject {
  property int activeModule: IslandTypes.Module.Clock
  property int previousModule: IslandTypes.Module.Clock

  function show(module) {
    if (activeModule !== module) {
      previousModule = activeModule
      activeModule = module
    }
  }

  function restore() {
    activeModule = previousModule
  }
}
