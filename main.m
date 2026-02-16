#import <Cocoa/Cocoa.h>

#define VERSION "0.1.3"
#define PID_PATH "/tmp/nanobar.pid"

@interface Delegate : NSObject <NSApplicationDelegate, NSMenuDelegate>
@end

@implementation Delegate {
    NSStatusItem *_item;
    NSStatusItem *_pusher;
    BOOL _hidden;
}

- (void)applicationDidFinishLaunching:(NSNotification *)n {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];

    _item = [bar statusItemWithLength:NSVariableStatusItemLength];
    _item.autosaveName = @"Item-0";
    _item.button.title = @"\u203A";

    _pusher = [bar statusItemWithLength:NSVariableStatusItemLength];
    _pusher.autosaveName = @"Pusher-0";
    _pusher.button.title = @"\u200B";

    NSMenu *menu = [NSMenu new];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    menu.delegate = self;
    _item.menu = menu;

    [@(getpid()).stringValue writeToFile:@PID_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)applicationWillTerminate:(NSNotification *)n {
    [[NSFileManager defaultManager] removeItemAtPath:@PID_PATH error:nil];
}

- (void)menuWillOpen:(NSMenu *)menu {
    NSEvent *e = NSApp.currentEvent;
    if (!e || e.buttonNumber == 0) {
        [menu cancelTrackingWithoutAnimation];
        _pusher.length = _hidden ? NSVariableStatusItemLength : 10000.0;
        _item.button.title = _hidden ? @"\u203A" : @"\u2039";
        _hidden = !_hidden;
    }
}

@end

int main(int argc, char *argv[]) {
    if (argc > 1) { printf("nanobar %s - minimal macOS menu bar manager\nUsage: nanobar\n", VERSION); return 0; }

    FILE *f = fopen(PID_PATH, "r");
    if (f) {
        int pid; if (fscanf(f, "%d", &pid) == 1 && kill(pid, 0) == 0) {
            fprintf(stderr, "nanobar: already running\n"); fclose(f); return 1;
        }
        fclose(f);
    }

    if (fork() != 0) return 0;
    setsid();

    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        app.activationPolicy = NSApplicationActivationPolicyAccessory;
        Delegate *delegate = [Delegate new];
        app.delegate = delegate;
        [app run];
    }
    return 0;
}
