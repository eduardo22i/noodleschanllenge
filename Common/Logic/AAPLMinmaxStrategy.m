/*
	Copyright (C) 2015 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Additions to the game model classes adding GameplayKit protocols for use with the minmax strategist.
 */

#import "AAPLMinmaxStrategy.h"

@implementation AAPLMove

- (instancetype)initWithColumn:(NSInteger)column withCount:(NSInteger) chipsCount {
    self = [super init];
    
    if (self) {
        _column = column;
        _chipsCount = chipsCount;
    }
    
    return self;
}

+ (AAPLMove *)moveInColumn:(NSInteger)column withCount:(NSInteger) chipsCount {
    return [[self alloc] initWithColumn:column withCount:chipsCount];
}

@end

@implementation AAPLPlayer (MinmaxStrategy)

- (NSInteger)playerId {
    return self.type;
}

@end

@implementation AAPLBoard (MinmaxStrategy)

#pragma mark - Managing players

- (NSArray<AAPLPlayer *> *)players {
    return [AAPLPlayer allPlayers];
}

- (AAPLPlayer *)activePlayer {
    return self.currentPlayer;
}

#pragma mark - Copying board state

- (__nonnull id)copyWithZone:(nullable NSZone *)zone {
    AAPLBoard *copy = [[[self class] allocWithZone:zone] init];
    [copy setGameModel:self];
    return copy;
}

- (void)setGameModel:(AAPLBoard *)gameModel {
	[self updateChipsFromBoard:gameModel];
    self.currentPlayer = gameModel.currentPlayer;
}

#pragma mark - Finding & applying moves

- (NSArray<AAPLMove *> *)gameModelUpdatesForPlayer:(AAPLPlayer *)player {
    
    NSMutableArray<AAPLMove *> *moves = [NSMutableArray arrayWithCapacity:AAPLBoard.width];
    
    NSInteger totalRunCount = 0;
    for (NSInteger column = 0; column < AAPLBoard.width; column++) {
        totalRunCount += [self chipsInColumn:column row:0];
    }
    
    for (NSInteger column = 0; column < AAPLBoard.width; column++) {
        NSInteger currentRunCount = totalRunCount;
        for (NSInteger chipsCount = 1; chipsCount <= [self chipsInColumn:column row:0]; chipsCount++) {

//        for (NSInteger chipsCount = [self chipsInColumn:column row:0]; chipsCount > 0; chipsCount--) {
            
            if ([self canRemoveChips:chipsCount inColumn:column]  && ((currentRunCount - chipsCount) > 0)) {
                AAPLMove* move = [AAPLMove moveInColumn:column withCount:chipsCount];
                move.player = player;
                [moves addObject:move];
            }
        }
    }
    
    // Will be empty if isFull.
    
    return moves;
}

- (void)applyGameModelUpdate:(AAPLMove *)gameModelUpdate {

   
    [self removeChips:gameModelUpdate.chipsCount inColumn:gameModelUpdate.column];
    
    NSInteger totalRunCount = 0;
    for (NSInteger column = 0; column < AAPLBoard.width; column++) {
        totalRunCount += [self chipsInColumn:column row:0];
    }
    if (totalRunCount != AAPLCountToWin) {
        self.currentPlayer = self.currentPlayer.opponent;
    }

}

#pragma mark - Evaluating board state

- (BOOL)isWinForPlayer:(AAPLPlayer *)player {
	// Use AAPLBoard's utility method to find all N-in-a-row runs of the player's chip.
    
    NSInteger totalRunCount = 0;
    for (NSInteger column = 0; column < AAPLBoard.width; column++) {
        totalRunCount += [self chipsInColumn:column row:0];
    }
    
    return totalRunCount == AAPLCountToWin && player == self.currentPlayer;
}

- (BOOL)isLossForPlayer:(AAPLPlayer *)player {
	// This is a two-player game, so a win for the opponent is a loss for the player.
    return [self isWinForPlayer:player.opponent];
}

- (NSInteger)scoreForPlayer:(AAPLPlayer *)player {
	/*
		Heuristic: the chance of winning soon is related to the number and length
		of N-in-a-row runs of chips. For example, a player with two runs of two chips each
		is more likely to win soon than a player with no runs.
	 
		Scoring should weigh the player's chance of success against that of failure,
		which in a two-player game means success for the opponent. Sum the player's number
		and size of runs, and subtract from it the same score for the opponent.
	 
	 	This is not the best possible heuristic for Four-In-A-Row, but it produces
		moderately strong gameplay. Try these improvements:
			- Account for "broken runs"; e.g. a row of two chips, then a space, then a third chip.
			- Weight the run lengths; e.g. two runs of three is better than three runs of two.
	*/
    
    
    NSInteger totalRunCount = 0;
    for (NSInteger column = 0; column < AAPLBoard.width; column++) {
        totalRunCount += [self chipsInColumn:column row:0];
    }
    if (totalRunCount == AAPLCountToWin && self.currentPlayer == player) {
        return 1;
    } else if (totalRunCount == AAPLCountToWin && self.currentPlayer != player) {
        return -1;
    }
    
    return 0;
}

@end
