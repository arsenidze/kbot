/*
Copyright © 2024 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"

	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
)

// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s %s called", appVersion, TeleToken)

		pref := telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		}

		kbot, err := telebot.NewBot(pref)
		if err != nil {
			log.Fatal(err)
			return
		}

		kbot.Handle(telebot.OnText, func(c telebot.Context) error {
			payload := c.Message().Payload
			log.Print(payload, c.Text())

			switch payload {
			case "hello":
				err = c.Send(fmt.Sprintf("Hello I am Kbot %s!", appVersion))
			}

			return err
		})

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
