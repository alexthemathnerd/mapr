import QtQuick

import Themes 1.0
import Components 1.0

BorderRectangle {
    property bool isLeftCorner: false
    property bool isRightCorner: false

    id: root
    width: 250
    color: Theme.colorSecondary
    bottomLeftRadius: isLeftCorner ? Theme.radiusLG: 0
    bottomRightRadius: isRightCorner ? Theme.radiusLG : 0
    borders.color: Theme.colorBorder
    borders.left.width: !isLeftCorner ? Theme.borderSM : 0
    borders.right.width: !isRightCorner ? Theme.borderSM : 0
}