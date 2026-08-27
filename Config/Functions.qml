pragma Singleton
import QtQuick

QtObject{
  function spanToHeight(spanH) {
    return (spanH * Metrics.buttonHeight + (spanH - 1) * Metrics.spacingInMenu)
  }

  function spanToWidth(spanW) {
    return (spanW * Metrics.buttonWidth + (spanW - 1) * Metrics.spacingInMenu)
  }
}
