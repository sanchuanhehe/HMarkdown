import { markConfig } from "../../../../../Index"
import { KEY_FONT_STYLE, KEY_LINE_SPACE, KEY_THEME } from "../../config/Constant"
import { MarkdownFontStyle, MarkdownTheme } from "../../config/MarkdownTheme"
import { Token, Tokens } from "../../core"
import { BlockQuote } from "./BlockQuote"
import { Code } from "./Code"
import { Heading } from "./Heading"
import { Hr } from "./Hr"
import { Html } from "./Html"
import { Inline } from "./Inline"
import { MList } from "./MList"
import { Paragraph } from "./Paragraph"
import { Table } from "./Table"

@ComponentV2
export struct MarkdownComponentV2 {
  @Param tokenList: Token[] = []
  @Consumer(KEY_THEME) theme?: MarkdownTheme
  @Consumer(KEY_LINE_SPACE) lineSpace?: number
  @Consumer(KEY_FONT_STYLE) fontStyle?: MarkdownFontStyle

  build() {
    Column({ space: this.lineSpace }) {
      ForEach(this.tokenList, (token: Token) => {
        if (token.type === 'hr') {
          Hr()
        } else if (token.type === 'heading') {
          Heading({ token: token as Tokens.Heading })
        } else if (token.type === 'space') {
          Stack()
        } else if (token.type === 'code') {
          Code({ token: token as Tokens.Code })
        } else if (token.type === 'blockquote') {
          BlockQuote({
            token: token as Tokens.Blockquote
          })
        } else if (token.type === 'paragraph') {
          Paragraph({
            token: token as Tokens.Paragraph
          })
        } else if (token.type === 'list') {
          MList({
            tokens: token as Tokens.List
          })
        } else if (token.type === 'text') {
          Inline({
            token: (this.tokenList[0] as Tokens.Text).tokens
          })
        } else if (token.type === 'table') {
          Table({
            token: token as Tokens.Table
          })
        } else if (token.type === 'html') {
          Html({ html: token.text })
        } else {
          markConfig.customBlockBuilder?.builder(token.type, token, this)
        }
      }
      )
    }
    .alignItems(HorizontalAlign.Start)
  }
}
