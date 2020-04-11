#!/usr/bin/env python3

import pathlib
import subprocess

import click

sby_files = list(pathlib.Path.cwd().glob('*.sby'))
assert len(sby_files) == 1, 'expected a single sby file in this directory'

SBY_FILE = sby_files[0]
TASKS = subprocess.check_output(
            ['sby', str(SBY_FILE), '--dumptasks'],
            universal_newlines=True).split()

@click.group(context_settings=dict(help_option_names=['-h', '--help']), chain=True)
@click.option('--task', '-t', required=True, type=click.Choice(TASKS))
@click.pass_context
def cli(ctx, task):
    ctx.ensure_object(dict)
    ctx.obj['task'] = task

@cli.command()
@click.pass_context
def sby(ctx):
    click.echo('Running sby with task {}'.format(ctx.obj['task']))
    subprocess.call(['sby', '-f', SBY_FILE.name, ctx.obj['task']])

@cli.command()
@click.pass_context
def gtkwave(ctx):
    click.echo('Running gtkwave with task {}'.format(ctx.obj['task']))
    workdir = pathlib.Path('{}_{}'.format(SBY_FILE.stem, ctx.obj['task']))
    vcds = list(workdir.joinpath('engine_0').glob('*.vcd'))
    subprocess.call(['gtkwave', str(vcds[0])])

if __name__ == '__main__':
    cli()
