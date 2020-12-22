import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.folderlistmodel 2.14
import Qaterial 1.0 as Qaterial

Qaterial.Menu
{
  id: root

  width: headline1.implicitWidth

  function copyToClipboard(labelName)
  {
    const textToCopy = `Qaterial.Label${labelName}`
    Qaterial.Clipboard.text = textToCopy
    Qaterial.SnackbarManager.show(`Text Type Copied! \n'${textToCopy}'`)
    root.close()
  }

  Qaterial.ItemDelegate
  {
    id: headline1
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHeadline1
    {
      text: "Headline1"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Headline1")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHeadline2
    {
      text: "Headline2"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Headline2")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHeadline3
    {
      text: "Headline3"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Headline3")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHeadline4
    {
      text: "Headline4"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Headline4")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHeadline5
    {
      text: "Headline5"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Headline5")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHeadline6
    {
      text: "Headline6"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Headline6")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelSubtitle1
    {
      text: "Subtitle1"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Subtitle1")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelSubtitle2
    {
      text: "Subtitle2"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Subtitle2")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelBody1
    {
      text: "Body1"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Body1")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelBody2
    {
      text: "Body2"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Body2")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelButton
    {
      text: "Button"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Button")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelOverline
    {
      text: "Overline"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Overline")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelCaption
    {
      text: "Caption"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Caption")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHint1
    {
      text: "Hint1"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Hint1")
  }

  Qaterial.ItemDelegate
  {
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    contentItem: Qaterial.LabelHint2
    {
      text: "Hint2"
      verticalAlignment: Text.AlignVCenter
    }

    onClicked: () => copyToClipboard("Hint2")
  }
}
