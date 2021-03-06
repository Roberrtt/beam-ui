import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.4
import Beam.Wallet 1.0
import "../utils.js" as Utils

Control {
    id: control
    spacing: 8

    property string  amount:          "0"
    property string  currencySymbol:  BeamGlobals.getCurrencyLabel(Currency.CurrBeam)
    property string  secondCurrencyLabel:       ""
    property string  secondCurrencyRateValue:   "0"
    property string  color:           Style.content_main
    property bool    error:           false
    property bool    showZero:        true
    property bool    showDrop:        false
    property int     fontSize:        14
    property bool    lightFont:       true
    property bool    boldFont:        false
    property string  iconSource:      ""
    property size    iconSize:        Qt.size(0, 0)
    property alias   copyMenuEnabled: amountText.copyMenuEnabled
    property alias   caption:         captionText.text
    property int     captionFontSize: 12
    property string  prefix:          ""
    property alias   fontSizeMode:    amountText.fontSizeMode

    function getAmountInSecondCurrency() {
        if (control.amount == "") return "-"
        var secondCurrencyAmount = 
            Utils.formatAmountToSecondCurrency(
                control.amount,
                control.secondCurrencyRateValue,
                control.secondCurrencyLabel);
        return control.prefix + (secondCurrencyAmount == "" ? "-" : secondCurrencyAmount);
    }

    contentItem: RowLayout{
        spacing: control.spacing

        SvgImage {
            Layout.alignment:   Qt.AlignVCenter
            source:             control.iconSource
            sourceSize:         control.iconSize
            visible:            !!control.iconSource
        }

        ColumnLayout {
            Layout.fillWidth:   true
            Layout.alignment:   Qt.AlignVCenter
            SFLabel {
                id:             captionText
                visible:        text.length > 0
                font.pixelSize: captionFontSize
                font.styleName: "Light"
                font.weight:    Font.Light
                color:          Qt.rgba(Style.content_main.r, Style.content_main.g, Style.content_main.b, 0.7)
            }

            RowLayout {
                Layout.fillWidth:   true
                SFLabel {
                    Layout.fillWidth:   true
                    id:              amountText
                    font.pixelSize:  fontSize
                    font.styleName:  lightFont ? "Light" : (boldFont ? "Bold" : "Regular")
                    font.weight:     lightFont ? Font.Light : (boldFont ? Font.Bold : Font.Normal)
                    color:           control.error ? Style.validator_error : control.color
                    text:            parseFloat(amount) > 0 || showZero ? prefix + [Utils.uiStringToLocale(amount), control.currencySymbol].join(" ") : "-"
                    onCopyText:      BeamGlobals.copyToClipboard(amount)
                    copyMenuEnabled: true
                }
                Image {
                    visible: showDrop
                    source:  "qrc:/assets/icon-down.svg"
                }
            }

            SFLabel {
                id:              secondCurrencyAmountText
                visible:         secondCurrencyLabel != ""
                font.pixelSize:  10
                font.styleName:  "Regular"
                font.weight:     Font.Normal
                color:           Qt.rgba(Style.content_main.r, Style.content_main.g, Style.content_main.b, 0.5)
                text:            getAmountInSecondCurrency()
                onCopyText:      BeamGlobals.copyToClipboard(secondCurrencyAmountText.text)
                copyMenuEnabled: true
            }
        }
    }
}