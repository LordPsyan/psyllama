package runner

import (
	"github.com/LordPsyan/psyllama/runner/llamarunner"
	"github.com/LordPsyan/psyllama/runner/psyllamarunner"
	"github.com/LordPsyan/psyllama/x/imagegen"
	"github.com/LordPsyan/psyllama/x/mlxrunner"
)

func Execute(args []string) error {
	if args[0] == "runner" {
		args = args[1:]
	}

	if len(args) > 0 {
		switch args[0] {
		case "--psyllama-engine":
			return psyllamarunner.Execute(args[1:])
		case "--imagegen-engine":
			return imagegen.Execute(args[1:])
		case "--mlx-engine":
			return mlxrunner.Execute(args[1:])
		}
	}
	return llamarunner.Execute(args)
}
